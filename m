Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0I3PqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:46:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:35602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab0I3PqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:46:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,260,1283756400"; 
   d="scan'208";a="662717991"
Date: Thu, 30 Sep 2010 23:45:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Microphone not working on PCI ID 8086:3b56
Message-ID: <20100930154557.GD11399@localhost>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
 <s5hsk0rtlun.wl%tiwai@suse.de>
 <AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
 <s5h4od7tf43.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4od7tf43.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:39:40PM +0800, Takashi Iwai wrote:
> At Thu, 30 Sep 2010 23:29:45 +0800,
> Jeff Chua wrote:
> > 
> > On Thu, Sep 30, 2010 at 9:14 PM, Takashi Iwai <tiwai@suse.de> wrote:
> > 
> > > Check /sys/modules/snd_hda_intel/parameters/model whether you really
> > > passed the correct value.
> > 
> > # cat /sys/module/snd_hda_intel/parameters/model
> > lenovo-x200,(null),(null),(null),(null),(null),(null),(null)
> 
> OK, and did you get the corresponding kernel message?

As a kindly reminder, these verbose options are pretty useful:

CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y

Thanks,
Fengguang
