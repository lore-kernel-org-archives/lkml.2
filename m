Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1CRRzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:55:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39647 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1CRRzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQZQXODkBsRc7SxD8pwoCvFALF2e2RMjOEhX8EC3dbSaPD1LX+Vt1T73lEIU2kYQls
         AhCChgTBQ+suLbBpK6z9CCN0+IRYxRM95PPLoGAXK/iGmFwCdT6S32Uya/Ei/5Sr79cf
         C26Q0xsTsejWQmlsRyZdi9XgHdKANL/T4fdrQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinRVWhsiee=MPZy7VeMg9TVMHH0k+n=pbn3QrBh@mail.gmail.com>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
	<s5hsk0rtlun.wl%tiwai@suse.de>
	<AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
	<s5h4od7tf43.wl%tiwai@suse.de>
	<20100930154557.GD11399@localhost>
	<AANLkTinnTeseJY4RDuGNkTjNE--QJ0Mw_S8FVKy_RT7h@mail.gmail.com>
	<20101001021548.GA7115@localhost>
	<AANLkTi=1=jT5LnjjP9uGMx-Q9kM7X6kx5=NeKK6Sa9g8@mail.gmail.com>
	<s5h8w2irzb9.wl%tiwai@suse.de>
	<AANLkTinRVWhsiee=MPZy7VeMg9TVMHH0k+n=pbn3QrBh@mail.gmail.com>
Date: Sat, 19 Mar 2011 01:55:10 +0800
Message-ID: <AANLkTinD-8Z-aLwUGArRJ4QPPVhGsEZks-5HCFoC693w@mail.gmail.com>
Subject: Re: Microphone not working on PCI ID 8086:3b56
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 1:10 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Fri, Oct 1, 2010 at 6:18 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
>>>
>>> Getting closer, but mic still not working.
>>
>> Jeff, give always alsa-info.sh output when you want someone else
>> looking into your HD-audio problem.  Without it, it's very hard to
>> follow what is wrong.
>> So, the mic is detected.  I guess you didn't set up the capture mixer
>> and else properly.
>
> Attached is the alsa-info output. I used alsamixer to set the Analog
> mic boost to 40db, and I can also see that alsa is detecting the
> external mic when I plug the mic in.
>
> - ALSA sound/pci/hda/patch_conexant.c:2354: CXT5066: external microphone absent
> + ALSA sound/pci/hda/patch_conexant.c:2348: CXT5066: external
> microphone detected
> Still no sound.

I just want to update you all now that I finally got the mic to work
on my X201s. It's the settings in the BIOS. Unlike earlier Thinkpad
models, the X201s BIOS has a special setting to enable/disable the
mic.  Bios setup: F1 -> Security -> I/O Ports -> Microphone -> Enable.
Since I trashed Windows on the X201s as soon as I power up the first
time  that could have disabled the mic by default.

Now, it's all working.

Thanks for all you help!

Jeff.
