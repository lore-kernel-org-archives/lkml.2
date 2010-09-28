Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0I1NdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:33:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0I1NdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IXn8R8C1aKTmynVLLxPgILCh2Hn25Iz1/UAZBJRnPT3GduvJUqtJ/+E10Wj1ZCe+fy
         Sp9dn97C+A98m7ewdV4UsLjAGf4NdkqTVqLk3hd+/Erhs/heIQDCZ7GeH7TwZKEwaU2y
         xxxYoWdbYx4nVD2xBnxCCFA1mQWpe5lmyG1Qg=
MIME-Version: 1.0
In-Reply-To: <s5haan3hwxi.wl%tiwai@suse.de>
References: <Pine.LNX.4.64.1009150615510.4515@boston.corp.fedex.com>
	<s5htylbxn6b.wl%tiwai@suse.de>
	<AANLkTimXBLM8POjeU6gET7twhV3SVxN0cS99ehLwf7DT@mail.gmail.com>
	<s5haan3hwxi.wl%tiwai@suse.de>
Date: Tue, 28 Sep 2010 21:33:11 +0800
Message-ID: <AANLkTimHO7OLrr+MN4pYmtOS7gF1qiXGP34Jkien0MpO@mail.gmail.com>
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

On Tue, Sep 28, 2010 at 2:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 28 Sep 2010 01:56:44 +0800,
> Jeff Chua wrote:
>>
>> On Mon, Sep 27, 2010 at 10:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Wed, 15 Sep 2010 06:32:22 +0800 (SGT),
>> > Did you try to play with model option for snd-hda-intel driver?
>> > For example, model=lenovo-x200 ?
>>
>> Didn't know there's such option. But I'll try it now. Is there an
>> option to if the driver is not compiled as a module?
>
> Yes, you can pass via a boot option like MODULENAME.OPTIONNAME=xxx,yyy,...
> In this case, snd-hda-intel.model=lenovo-x200

Tried, still no mic. Perhaps I'm not using the right driver. Which one
should I enable?

CONFIG_SND_HDA_CODEC_CONEXANT
CONFIG_SND_HDA_CODEC_INTELHDMI
CONFIG_SND_HDA_CODEC_REALTEK


Thanks,
Jeff
