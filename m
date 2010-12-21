Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab0LUAsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:48:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:34286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab0LUAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:48:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,205,1291622400"; 
   d="scan'208";a="689107365"
Subject: Re: [concept & "good taste" review] persistent store
From: Huang Ying <ying.huang@intel.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <AANLkTikULE_Jncjs=PkARjZyxb=f+t=4J8g8LQL+L=BZ@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	 <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	 <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	 <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	 <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	 <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	 <4D0BEE1F.7020008@zytor.com>
	 <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	 <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
	 <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
	 <20101219091752.GA16150@liondog.tnic>
	 <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
	 <1292813234.8743.66.camel@yhuang-dev>
	 <AANLkTikULE_Jncjs=PkARjZyxb=f+t=4J8g8LQL+L=BZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 08:48:14 +0800
Message-ID: <1292892494.8743.76.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 01:19 +0800, Tony Luck wrote:
> On Sun, Dec 19, 2010 at 6:47 PM, Huang Ying <ying.huang@intel.com> wrote:
> > 8KB is about 100-200 lines message, sometimes it may be not enough for
> > all necessary information.  But in fact, we can use multiple ERST
> > records to save one kernel message dumping. So the real limitation is
> > just total storage capacity.
> 
> We can - but it will be a bit messy within my pstore + platform driver
> framework (I'd have to have erst tell pstore that it could handle some
> larger size, 2x or 3x the actual record size and then break a write
> into pieces. Presumably re-assemble on the read side too).

If persistent storage driver (such as ERST) implements kmsg_dumper by
themselves, that should be easier to use multiple records for one
message dumping request.

Best Regards,
Huang Ying


