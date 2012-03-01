Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab2CANp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:45:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282Ab2CANp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:45:27 -0500
Date: Thu, 1 Mar 2012 14:45:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
Message-ID: <20120301134508.GA16432@elte.hu>
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
 <20120227115905.GB9943@elte.hu>
 <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
 <4F4C4D5C.70908@zytor.com>
 <20120228082422.GG21106@elte.hu>
 <ad7809d2-4c66-4d55-929b-2c1ae76f1420@email.android.com>
 <CAELBVzAPHfnZWRTU82V3yHuW9iY8SfAgDNmro1q4dpOvKTwnBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELBVzAPHfnZWRTU82V3yHuW9iY8SfAgDNmro1q4dpOvKTwnBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> On 28 February 2012 04:31, H. Peter Anvin <hpa@zytor.com> wrote:
> > Better yet, fix the problem...
> >
> 
> It appears that some attempts have been made at fixing this problem already:
> 
> https://lkml.org/lkml/2011/7/6/6
> https://lkml.org/lkml/2011/7/7/480
> 
> So perhaps I can just turn off that config setting for now.  
> I'm going away for a few days, but I'll try to fix up the 
> patch series next week.

Nor does that build warning/failure appear to be caused by your 
patches, it just happened to trigger in the config I sent you.

Thanks,

	Ingo
