Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2AFLKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:10:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab2AFLKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:10:14 -0500
Date: Fri, 6 Jan 2012 12:08:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106110812.GA24369@elte.hu>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
 <20120105182846.GQ11715@one.firstfloor.org>
 <4F0630CC.7050001@zytor.com>
 <20120106014748.GS11715@one.firstfloor.org>
 <4F06566B.8080708@zytor.com>
 <20120106094922.GU11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106094922.GU11715@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> You would slow a critical fast path operation down for 
> something that never happens?!?  There were big differences 
> between strings and the unrolled loop for several.

AFAICS Jan's approach speeds up memset(), so what you say is 
100% pure nonsense.

Thanks,

	Ingo
