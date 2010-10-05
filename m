Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0JEHyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:54:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861Ab0JEHx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:53:58 -0400
Date: Tue, 5 Oct 2010 09:53:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dilinger@queued.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: Don't retry EC commands forever
Message-ID: <20101005075345.GF23608@elte.hu>
References: <20101001171719.4448E9D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001171719.4448E9D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> From: Paul Fox <pgf@laptop.org>
> 
> Avoids a potential infinite loop

Was this infinite loop observed in practice? I.e. should this get into 
.36 and into -stable?

	Ingo
