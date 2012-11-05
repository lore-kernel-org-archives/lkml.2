Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2KEN0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:26:38 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:40018 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab2KEN0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:26:36 -0500
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6s8qrP0itLgCyv1mBnekc-7K1n_q-kTKUR=MOJ57W_a1w@mail.gmail.com>
Date: Mon, 5 Nov 2012 14:25:33 +0100
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9F4DFD1-4BF4-423C-B749-74E37D51192A@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <50925C49.7060004@ti.com> <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net> <50938108.5040507@ti.com> <40797D3D-D62C-4E15-B0DF-75636C1637EE@antoniou-consulting.com> <CACxGe6s8qrP0itLgCyv1mBnekc-7K1n_q-kTKUR=MOJ57W_a1w@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 5, 2012, at 1:22 AM, Grant Likely wrote:

> On Fri, Nov 2, 2012 at 8:43 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> Assuming that we do work on a DT object format, and that the runtime resolution mechanism is approved,
>> then I agree that this part of the capebus patches can be dropped and the functionality assumed by generic
>> DT core.
>> 
>> The question is that this will take time, with no guarantees that this would be acceptable from
>> the device tree maintainers. So I am putting them in the CC list, to see what they think about it.
> 
> This is actually exactly the direction I want to go with DT, which the
> ability to load supplemental DT data blobs from either a kernel module
> or userspace using the firmware loading infrastructure.
> 
> g.

Hi Grant,

That's pretty much our use case.

Regards

-- Pantelis


