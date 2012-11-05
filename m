Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2KETkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:40:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2KETkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:40:43 -0500
MIME-Version: 1.0
In-Reply-To: <5097E1AC.5080806@gmail.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
 <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
 <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
 <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <50925C49.7060004@ti.com> <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net>
 <50938108.5040507@ti.com> <40797D3D-D62C-4E15-B0DF-75636C1637EE@antoniou-consulting.com>
 <CACxGe6s8qrP0itLgCyv1mBnekc-7K1n_q-kTKUR=MOJ57W_a1w@mail.gmail.com>
 <C9F4DFD1-4BF4-423C-B749-74E37D51192A@antoniou-consulting.com>
 <CACxGe6ubcRqDEGyRbNmwvAMGg5ujAKvPRWe9Vmd9tiHeB7=qNw@mail.gmail.com> <5097E1AC.5080806@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Nov 2012 19:40:22 +0000
X-Google-Sender-Auth: TKNqFOaTzco6BSkHee91Twzlhtk
Message-ID: <CACxGe6v4XO64B-Xdgo+WkO+H-Snm5Um-rL9GOvGMY1AWo14Grg@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
To: Rob Herring <robherring2@gmail.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Alan Tull <atull@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:56 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 11/05/2012 08:34 AM, Grant Likely wrote:
>> Good. I'm about 80% though putting together a project plan of what is
>> required to implement this. I'll post it for RFC shortly. I would
>> appreciate feedback and help on flushing out the design.
>
> The FPGA folks are also interested in dynamic DT configuration. There's
> been some discussion and postings on the DT list in the last few months
> you may have missed. It's maybe not completely the same use case, but
> there is some overlap here.

It should be very similar. I'll see if I can dig up those conversations.

g.
