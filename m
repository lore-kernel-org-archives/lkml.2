Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0JACP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:15:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:19818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0JACPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:15:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,262,1283756400"; 
   d="scan'208";a="842585036"
Date: Fri, 1 Oct 2010 10:15:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Microphone not working on PCI ID 8086:3b56
Message-ID: <20101001021548.GA7115@localhost>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
 <s5hsk0rtlun.wl%tiwai@suse.de>
 <AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
 <s5h4od7tf43.wl%tiwai@suse.de>
 <20100930154557.GD11399@localhost>
 <AANLkTinnTeseJY4RDuGNkTjNE--QJ0Mw_S8FVKy_RT7h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinnTeseJY4RDuGNkTjNE--QJ0Mw_S8FVKy_RT7h@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 02:08:09AM +0800, Jeff Chua wrote:
> On Thu, Sep 30, 2010 at 11:45 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > As a kindly reminder, these verbose options are pretty useful:
> >
> > CONFIG_SND_VERBOSE_PROCFS=y
> > CONFIG_SND_VERBOSE_PRINTK=y
> > CONFIG_SND_DEBUG=y
> > CONFIG_SND_DEBUG_VERBOSE=y
> 
> Attached alsa log and dmesg with above enabled.

Jeff, this should make your mic work.

Thanks,
Fengguang

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a6c68cb..c0c2b33 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3110,6 +3110,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
+ 	SND_PCI_QUIRK(0x17aa, 0x2156, "Lenovo X201s", CXT5066_THINKPAD),
  	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
  	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G series", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x390a, "Lenovo S10-3t", CXT5066_IDEAPAD),
