Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0I3Rbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:31:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab0I3Rbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lUN9Z1/7zeCyxke24ODAOvdO5b3sbkNV3libzODqPxuE8gqYjlW0JWAgd/KOIl+V/f
         nPJzN2v1jhZL5uG15QDHDYJ/3S6n/yZ8xuj9zv+DYLZ2BRIdyRHduCwp3YMEXJ7I46GS
         NYmep8vvLjOMA2+qp1u/pEcHa+ZEw9qU0v5Ug=
MIME-Version: 1.0
In-Reply-To: <s5h4od7tf43.wl%tiwai@suse.de>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
	<s5hsk0rtlun.wl%tiwai@suse.de>
	<AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
	<s5h4od7tf43.wl%tiwai@suse.de>
Date: Fri, 1 Oct 2010 01:31:33 +0800
Message-ID: <AANLkTinuE=p3Pe0JDKQb=BstpZ=r-xXu3uSZueT2HFCR@mail.gmail.com>
Subject: Re: Microphone not working on PCI ID 8086:3b56
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:39 PM, Takashi Iwai <tiwai@suse.de> wrote:

>> # cat /sys/module/snd_hda_intel/parameters/model
>> lenovo-x200,(null),(null),(null),(null),(null),(null),(null)
>
> OK, and did you get the corresponding kernel message?

HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA device list:
#0: HDA Intel at 0xf2520000 irq 45


Thanks,
Jeff.
