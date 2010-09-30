Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0I3Pi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:38:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:33733 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0I3Pi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,260,1283756400"; 
   d="scan'208";a="330549853"
Date: Thu, 30 Sep 2010 23:38:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Microphone not working on PCI ID 8086:3b56
Message-ID: <20100930153820.GB11399@localhost>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
 <s5hsk0rtlun.wl%tiwai@suse.de>
 <AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:29:45PM +0800, Jeff Chua wrote:
> On Thu, Sep 30, 2010 at 9:14 PM, Takashi Iwai <tiwai@suse.de> wrote:
> 
> > Check /sys/modules/snd_hda_intel/parameters/model whether you really
> > passed the correct value.
> 
> # cat /sys/module/snd_hda_intel/parameters/model
> lenovo-x200,(null),(null),(null),(null),(null),(null),(null)

Would you run http://www.alsa-project.org/alsa-info.sh and show us the
collected info?

> >> in my case as I'm not using udev. Here's a patch to take away the default so non-udev will still
> >> works.
> >
> > Wow, what's a conservative system :)
> 
> Keeping things simple :)  and my / root filesystem is mounted read-only.

Sounds more like "sophisticated immune" than "simple" :)

Thanks,
Fengguang
