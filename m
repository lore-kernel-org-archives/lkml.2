Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0I3P3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:29:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63048 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab0I3P3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jRD38zgrhd5sLa2/qDY+m/7TW6t8pvymgKZHCygqDEJF6YOw6vs2nZpDNQ5vK5eSvz
         1v2bavp4Hs0UlIAKPgCrKp5hXFJEuga7i4toljlhQ3W48uSygOq/2PKOmtiJP5lZhx34
         DDxjxZq9efYudqBKS/FL+KV3Cud09YqUoabTg=
MIME-Version: 1.0
In-Reply-To: <s5hsk0rtlun.wl%tiwai@suse.de>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
	<s5hsk0rtlun.wl%tiwai@suse.de>
Date: Thu, 30 Sep 2010 23:29:45 +0800
Message-ID: <AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
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

On Thu, Sep 30, 2010 at 9:14 PM, Takashi Iwai <tiwai@suse.de> wrote:

> Check /sys/modules/snd_hda_intel/parameters/model whether you really
> passed the correct value.

# cat /sys/module/snd_hda_intel/parameters/model
lenovo-x200,(null),(null),(null),(null),(null),(null),(null)

>> in my case as I'm not using udev. Here's a patch to take away the default so non-udev will still
>> works.
>
> Wow, what's a conservative system :)

Keeping things simple :)  and my / root filesystem is mounted read-only.

Thanks,
Jeff
