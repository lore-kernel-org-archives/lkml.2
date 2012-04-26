Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2DZTW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:22:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38281 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284Ab2DZTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:22:26 -0400
Message-ID: <4F99A06D.6070401@gmail.com>
Date: Thu, 26 Apr 2012 21:22:21 +0200
From: Kristoffer Eriksson <kristoffer.ericson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?H=E5var_N=F8vik?= <havar.novik@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        alan@linux.intel.com
Subject: Re: Bug reports on the psb-gfx driver
References: <CAJqTQGEe6rGw4_f-7o2DUZs1J9a=pACuX4KYkLfA0_McMC2Ukg@mail.gmail.com> <4F8D532E.4000305@gmail.com> <CAJqTQGFD=CCRQGFrhiVk5dEp0bCZ7KbSOsd0HSi_jeSQ4yd9bg@mail.gmail.com> <20120418222137.0303fe47@pyramind.ukuu.org.uk>
In-Reply-To: <20120418222137.0303fe47@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox skrev 2012-04-18 23:21:
>> That frequency seems about the same as the one I'm experiences. All though
>> some times it's more often, but I can't say I've done anything special at
>> the same time.
>>
>> 3.3.2-1-ARCH
>> Intel(R) Atom(TM) CPU Z520 @ 1.33GHz
>>
>> Attachment: dmesg ouput
>>
> What X display server are you using (fbdev or other ?). Also I see a few
> writes to the brightness in the log - did you fiddle with the brightness
> by hand at all ?
Alan,

Without looking at the code I can say that those brightness commands are 
not related to this
issue since Ive been having them since the first working kernel version.
Havent had time to look at the code but Ive understod them to happen 
simply when you
press a key to return from backlight suspend. Something like the default 
brightness setting that gets invoked
after return from suspend.

Håvar see
[ 7659.177126] gma500 0000:00:02.0: Backlight lvds set brightness 186a186a

while I see
[....] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12



>
> Either way I suspect the only way to find this is to verify a
> configuration it occurs on, go back a kernel, verify it doesn't happen
> there and then build a kernel to the point in the git tree before the
> gma500 patches were changed (to check its not caused by something else
> such as an ACPI change), then try and find which one caused it.
Will do further fresh builds to see if I can reproduce the blanking 
issue and also
test out the patch.


> That will be tedious but unfortunately I've got no documentation or other
> good ways to chase this down.
>
> Alan
>

