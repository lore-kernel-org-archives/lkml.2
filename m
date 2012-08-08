Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2HHGSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:18:18 -0400
Received: from 1wt.eu ([62.212.114.60]:5682 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab2HHGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:18:15 -0400
Date: Wed, 8 Aug 2012 08:17:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Miller <davem@davemloft.net>
Cc: albcamus@gmail.com, chris@arachsys.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to bnx2-mips-09-6.2.1b
Message-ID: <20120808061758.GA15255@1wt.eu>
References: <20120713130405.GS13885@arachsys.com> <CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com> <20120807.225800.1450928472652058111.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807.225800.1450928472652058111.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 10:58:00PM -0700, David Miller wrote:
> From: Jike Song <albcamus@gmail.com>
> Date: Wed, 8 Aug 2012 13:50:42 +0800
> 
> > On Fri, Jul 13, 2012 at 9:04 PM, Chris Webb <chris@arachsys.com> wrote:
> >> Commit c2c20ef43d00 "bnx2: Update driver to use new mips firmware"
> >> updated the bnx2 driver to use bnx2-mips-09-6.2.1b in place of
> >> bnx2-mips-09-6.2.1a, but didn't replace the copy of bnx2-mips-09-6.2.1a
> >> in firmware/bnx2/ with the new version.
> >>
> >> This means that the bnx2 driver stopped working altogether for users who
> >> use CONFIG_FIRMWARE_IN_KERNEL to compile firmware together with drivers
> >> into their kernel, rather than having a runtime firmware loader.
> >>
> > 
> > Still not fixed in mainline? I encountered the same problem with
> > v3.6-rc1-133-g42a579a.
> 
> The current firmware for all drivers are not distributed in the kernel
> sources any longer, they are maintained in a completely seperate
> repository.
> 
> The old ones are just kept around in the kernel sources for
> compatability.
> 
> This is a FAQ.

Well, if the drivers provided with the kernel don't work out of the box
anymore, maybe we should also move them to a separate repository. All it
is going to do otherwise is to cause invalid bug reports because users
don't understand why using the latest driver does not work.

That way it would be clear that an in-kernel driver has to be self-sustaining
to be maintainable, otherwise it has nothing to do there.

Just my 2 cents,
Willy

