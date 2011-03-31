Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1CaLNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:13:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1CaLNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:13:42 -0400
Date: Thu, 31 Mar 2011 13:13:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331111323.GA24672@elte.hu>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
 <20110331065036.GC5938@elte.hu>
 <20110331065805.GG5938@elte.hu>
 <20110331093723.GE24046@sgi.com>
 <20110331095705.GA23319@elte.hu>
 <4D9457BF.1040601@redhat.com>
 <20110331104601.GA8577@elte.hu>
 <4D945C4D.5090104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D945C4D.5090104@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Avi Kivity <avi@redhat.com> wrote:

> How important is udelay() for hardware timing these days, btw?

Seems popular enough:

  earth4:~/tip> git grep -w udelay drivers/ | wc -l
  4843

And while it's probably less important than it used to be, we cannot really 
know for sure. This is one of the rare occasions where some modest amount of 
fear, uncertainty and doubt is justified.

Thanks,

	Ingo
