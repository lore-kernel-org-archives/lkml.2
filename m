Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1KUDGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:06:46 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60217 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1KUDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:06:45 -0500
Date: Mon, 21 Nov 2011 12:06:40 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111121030640.GI32505@gamma.logic.tuwien.ac.at>
References: <20111102031345.GA10851@gamma.logic.tuwien.ac.at> <1320204101.31823.140.camel@wwguy-huron> <20111104045817.GA25778@gamma.logic.tuwien.ac.at> <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com> <20111109051152.GA16006@gamma.logic.tuwien.ac.at> <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel, hi all,

sorry for the long silence. I was a bit travelling and off,


On Mi, 09 Nov 2011, Emmanuel Grumbach wrote:
> > On Di, 08 Nov 2011, Emmanuel Grumbach wrote:
> > > I would like to see what happens in terms or power.
> > > Please set the power debug flag: modprobe iwlwifi debug=0x100
> >
> > > It may be worth to disable Link Power save too. I would be glad if you
> > > could try this patch (attached and inlined), with the power debug flag
> > > set.

I have now disabled the debug option again. And rebuild some new kernels
(3.2.0-rc1 and top git).

And what I stil see is that the tx-queue gets stuck and does not
recover without rmmod iwlwif.

hwq 11: read=0 write=0 stop=1 swq_id=0x2e (ac 2/hwq 11)

But I still am using the patch that you sent to disable power save,
so it is not only this one.

If you think I shouuld turn on power debug again and see hope that
it happens again, let me know.

Furthermore, I have now seen hiccups on my home router, too, at
times. There is recovers normally by itself, but still.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Program aborting:
Close all that you have worked on.
You ask far too much.
                       --- Windows Error Haiku
