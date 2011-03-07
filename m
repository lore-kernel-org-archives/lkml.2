Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1CGW12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:27:28 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:41062 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1CGW10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ez03xF70uQfyvXL1suaCHsEMpnkwSWi9J9ToALvIgbvtCJa+RJvUi7eDZPSrNiQ8JK
         j+WRRzQ4dxjvxTG9AmXxX5azEGJjt1uOZlo4sVgi3K/jQjciNegj24ickkFTYvLQtdOY
         tWFuR+1GqYFxHh4fSv3kiGhCsS0tvA2nse8J8=
MIME-Version: 1.0
In-Reply-To: <op.vrzj35j33ri7v4@arend-laptop>
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
	<op.vryqz6qt3ri7v4@arend-laptop>
	<AANLkTinbrbkUO-ycAsX4cLEoM6avPeiYEZZ-zKtavfqq@mail.gmail.com>
	<op.vry7kwq83ri7v4@arend-laptop>
	<AANLkTinWOFPUqmv6PbQMy6xnsAptGKUjoAHoxB65LCy9@mail.gmail.com>
	<op.vrzj35j33ri7v4@arend-laptop>
Date: Mon, 7 Mar 2011 23:27:26 +0100
Message-ID: <AANLkTikcFqVYODzQ1mv9GY5wUVND1ug2kDb=XcMeACzE@mail.gmail.com>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi switch
 to OFF
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 7:25 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On Mon, 07 Mar 2011 18:29:47 +0100, Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> On Mon, Mar 7, 2011 at 2:54 PM, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> I don't know what the origin is of your kernel so please provide some
>>> details on that.
>>
>> What kind of information do you need ?
>>
>> As you probably noticed the kernel I'm running is 2.6.38-rc6.
>>
>
> Yup. However, that is not unique by itself. Did you get it from a git
> repository like linux-next maintained by Stephen Rothwell or linux-2.6
> maintained by Linus Torvalds, or did you download a kernel snapshot from
> ftp.kernel.org.


2.6.38-rc6 is a tag, so it uniquely identify the kernel release
whatever the tree you're using. But yes I'm using mainline tree.

>
>>
>> Revelant part of lscpi:
>>
>> 12:00.0 Network controller: Broadcom Corporation Device 4727 (rev 01)
>>        Subsystem: Dell Device 0010
>>        Flags: bus master, fast devsel, latency 0, IRQ 17
>>        Memory at fbb00000 (64-bit, non-prefetchable) [size=16K]
>>        Capabilities: <access denied>
>>        Kernel driver in use: brcm80211
>>        Kernel modules: brcm80211
>>
>
> Always useful to know what hardware you are using. Thanks.
>
>>
>>> The patch itself can be found in the linuxdriver email
>>> archive:
>>>
>>>
>>> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-January/011381.html
>>>
>>
>> Do you want me to give it a try ?
>>
>
> I don't think it will apply cleanly, but sure go ahead.
>
>>
>>> Not sure whether it applies to whatever you have. I just tried your
>>> scenario
>>> with my driver and hardware and no freezes during boot.
>>
>> My scenario is:
>>
>>   - set the switch to OFF
>>   - insmod the module
>>   - bring up/configure the interface
>
> That's a bit different, but could you elaborate on the last step. Are you
> using iw, wpa_supplicant, etc. or relying on NetworkManager.

last step is (for example):

   iw dev wlan0 scan

Thanks
-- 
Francis
