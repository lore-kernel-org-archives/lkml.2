Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1LGAio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:38:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:15821 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab1LGAin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,309,1320652800"; 
   d="scan'208";a="82966153"
Subject: Re: [PATCH v4] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
From: Zhang Rui <rui.zhang@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
In-Reply-To: <1323092402.4838.6.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
	 <20111205123217.GF3143@elte.hu>
	 <1323092402.4838.6.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 08:36:23 +0800
Message-ID: <1323218183.9574.1434.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 21:40 +0800, Matt Fleming wrote:
> On Mon, 2011-12-05 at 13:32 +0100, Ingo Molnar wrote:
> > * Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > > Zhang, it'd be good to make sure that this still actually 
> > > fixes your problem on CONFIG_X86_32. Also, if anyone has a 
> > > Macbook Pro/Macbook Air, please make sure that this patch 
> > > doesn't cause your machine to reboot/hang, as those machines 
> > > tend to be the ones that this problem.
> > 
> > Ping - has it been tested on an affected box, can we apply it to 
> > the x86 tree?
> 
> I've not had any response from Zhang or anyone with a macbook. So as far
> as I know, no, this v4 patch hasn't been tested on any of the affected
> machines.
> 
> Zhang, could you test this patch, please? Or pass it along to someone
> else who can do the testing. Thanks.
> 
Sure.
I can test it tomorrow because I'm in a training these two days.

thanks,
rui

