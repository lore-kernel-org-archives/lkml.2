Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0GFCe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:34:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48329 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0GFCeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kMBrmTKQigfyS4jUCLbWx1lf7FHbHoOEGq2xeJcauzj2rUycsvM0FkR3QKi485KRpH
         IyHK6MaumBGaOy3GDgOkFWSXagcD9uVQcrN8K0hASyE1Cf8UuXqhl6xcCbb/pWLhU86K
         CP++KCPqaeGdV49YTVamEUkRtBVPdMDF5SK/o=
MIME-Version: 1.0
In-Reply-To: <4C3221FA.6070507@gmail.com>
References: <20100703221056.GA17817@animx.eu.org>
	<20100704231926.GA1780@animx.eu.org>
	<201007051927.17001.marvin24@gmx.de>
	<4C3221FA.6070507@gmail.com>
Date: Tue, 6 Jul 2010 10:34:22 +0800
Message-ID: <AANLkTil2pHW4C-g-DPKUy-yvDfB3fedQC270RfqL3Gnt@mail.gmail.com>
Subject: Re: Radeon KMS doesn't work.
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Marvin <marvin24@gmx.de>, linux-kernel@vger.kernel.org,
       xorg-driver-ati@lists.x.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 2:18 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 07/05/2010 10:27 AM, Marvin wrote:
>>
>> Hi Wakko,
>>
>> as nobody seems to have answered yet, I think it's better that you file a
>> bug
>> against the radeon driver (bugs.freedesktop.org, one bug for each defect).
>> There may be similar bugs already, so please check this also.
>>
>> Thanks
>>
>> Marvin
>>
>> Am Montag 05 Juli 2010, 01:19:26 schrieb Wakko Warner:
>>>
>>> Wakko Warner wrote:
>>>>
>>>> I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
>>>> PCI ID 1002:4c57 sub 1028:0149).
>>>>
>>>> Immediately when radeon.ko is loaded, the screen goes blank (The
>>>> backlight stays on).  I have fbcon compiled into the kernel (I also
>>>> tried as module). I am unable to get the screen to work again until I
>>>> reboot.  The logs did not appear to have any errors after the module
>>>> loaded.  The system was still responsive on the network.
>>>>
>>>> I tried kernels 2.6.33 and 2.6.34.
>>>>
>>>> I can provide kernel output if needed.
>>>
>>> I need to add that if I use modeset=0, the screen does not blank.
>>>
>>> Also 2.6.34 (with modeset=0) doesn't do 3D very well on this system.
>>>  Some
>>> objects look ok, some are garbled, some do not appear at all.  The gears
>>> from xscreensaver does not show up at all.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
> I've hit a couple of things with radeon as well.. the first was this:
> http://lkml.org/lkml/2010/6/6/172
> (if your hitting this issue, then the patch should work and/or it should
> already be in the main tree).
>
> then a few days ago hit another:
> https://bugzilla.kernel.org/show_bug.cgi?id=16335
> (keep in mind still uncertain on a fix for this, reverting the commit gets
> me up and running(I created a patch, but an umsure if it's a right
> solution)).

I think this is the same cases with (http://lkml.org/lkml/2010/7/5/44)
And the fix for this bug is in -tip tree, commit 2463eb8

Could you please try following patch?
http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249

>
> if none of these are what your hitting, then maybe(if you can) do a bisect
> on this!
>
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
