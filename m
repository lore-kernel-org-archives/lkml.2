Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1JZUCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:02:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:5152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1JZUCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:02:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,411,1315206000"; 
   d="scan'208";a="78312285"
Subject: Re: [Ilw] Re: iwlagn is getting very shaky
From: wwguy <wey-yi.w.guy@intel.com>
To: Richard Yao <ryao@cs.stonybrook.edu>
Cc: Norbert Preining <preining@logic.at>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <CABDyM6T-_UWjQtb9E8Yie1kj5UpDHZNRTb13xJBt=YFczbwxZA@mail.gmail.com>
References: <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319119852.2111.2.camel@wwguy-ubuntu>
	 <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	 <20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	 <1319601333.14693.19.camel@wwguy-ubuntu>
	 <20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	 <1319601654.14693.20.camel@wwguy-ubuntu>
	 <20111026043419.GA30368@gamma.logic.tuwien.ac.at>
	 <CABDyM6T-_UWjQtb9E8Yie1kj5UpDHZNRTb13xJBt=YFczbwxZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 12:56:05 -0700
Message-ID: <1319658965.14693.25.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 21:54 -0700, Richard Yao wrote:
> Dear Norbert,
> 
> Try doing "iwconfig wlan0 rts 0". As I said less than an hour ago in
> my rather lengthy post to the Linux mailing list, that made things
> better for me, but not perfect.
> 
> Speaking of which, that post described my findings on why I was having
> wireless issues that I did not post several weeks ago because I didn't
> think anyone would care. Since people do seem to care, I probably
> should have CCed that email to everyone else that was on people's CC
> lists, but I am new to mailing lists (and to Linux), so I did not
> think of it until now.
> 
yes we care, sorry to miss your email thread. please provide  more
information about your issue.

Thanks
Wey

> 
> On Wed, Oct 26, 2011 at 12:34 AM, Norbert Preining <preining@logic.at> wrote:
> > On Di, 25 Okt 2011, wwguy wrote:
> >> > But *I* cannot be sure about it ;-)
> >> >
> >> Are you seeing this without suspend/resume?
> >
> > Yes. I just shut down and started, and the same happens again. If you
> > need the dmesg output let me know.
> >
> > Best wishes
> >
> > Norbert
> > ------------------------------------------------------------------------
> > Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> > JAIST, Japan                                 TeX Live & Debian Developer
> > DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> > ------------------------------------------------------------------------
> > RUNCORN (n.)
> > A peeble (q.v.) which is larger that a belper (q.v.)
> >                        --- Douglas Adams, The Meaning of Liff
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> _______________________________________________
> ilw mailing list
> ilw@linux.intel.com
> http://linux.intel.com/mailman/listinfo/ilw


