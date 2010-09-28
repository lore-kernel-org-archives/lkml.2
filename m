Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0I1Nmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:42:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:26176 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab0I1Nmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="661914665"
Date: Tue, 28 Sep 2010 21:42:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Microphone not working on PCI ID 8086:3b56
Message-ID: <20100928134236.GA15827@localhost>
References: <Pine.LNX.4.64.1009150615510.4515@boston.corp.fedex.com>
 <s5htylbxn6b.wl%tiwai@suse.de>
 <AANLkTimXBLM8POjeU6gET7twhV3SVxN0cS99ehLwf7DT@mail.gmail.com>
 <s5haan3hwxi.wl%tiwai@suse.de>
 <AANLkTimHO7OLrr+MN4pYmtOS7gF1qiXGP34Jkien0MpO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimHO7OLrr+MN4pYmtOS7gF1qiXGP34Jkien0MpO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:33:11PM +0800, Jeff Chua wrote:
> On Tue, Sep 28, 2010 at 2:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
> > At Tue, 28 Sep 2010 01:56:44 +0800,
> > Jeff Chua wrote:
> >>
> >> On Mon, Sep 27, 2010 at 10:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
> >> > At Wed, 15 Sep 2010 06:32:22 +0800 (SGT),
> >> > Did you try to play with model option for snd-hda-intel driver?
> >> > For example, model=lenovo-x200 ?
> >>
> >> Didn't know there's such option. But I'll try it now. Is there an
> >> option to if the driver is not compiled as a module?
> >
> > Yes, you can pass via a boot option like MODULENAME.OPTIONNAME=xxx,yyy,...
> > In this case, snd-hda-intel.model=lenovo-x200
> 
> Tried, still no mic. Perhaps I'm not using the right driver. Which one
> should I enable?
> 
> CONFIG_SND_HDA_CODEC_CONEXANT

The "lenovo-x200" model is provided by the above codec.

> CONFIG_SND_HDA_CODEC_INTELHDMI
> CONFIG_SND_HDA_CODEC_REALTEK

It's easier to enable all of them. They are small modules.

Thanks,
Fengguang
