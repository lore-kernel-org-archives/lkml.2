Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1HEKpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:45:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab1HEKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:45:04 -0400
Date: Fri, 5 Aug 2011 12:43:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        dilinger@queued.net, pgf@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, olpc: Wait for last byte of EC command to be
 accepted
Message-ID: <20110805104356.GA13055@elte.hu>
References: <20110726154226.93A9F9D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726154226.93A9F9D401C@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.8 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.2 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> From: Paul Fox <pgf@laptop.org>
> 
> When executing EC commands, only waiting when there are still more bytes to
> write is usually fine. However, if the system suspends very quickly after
> a call to olpc_ec_cmd(), the last data byte may not yet be transferred to
> the EC, and the command will not complete.
> 
> This solves a bug where the SCI wakeup mask was not correctly written
> when going into suspend.

What did that result in - a resume hang? (i.e. how urgent is this fix 
- v3.1 material or v3.2 material?)

Thanks,

	Ingo
