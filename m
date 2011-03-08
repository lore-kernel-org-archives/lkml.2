Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1CHJlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:41:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38206 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1CHJk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E6bpJ2mD34KxatnfnnMhe/Rwma8HGNNfDIsz/tC9KAflL82mgFb0divv/DGbh4ZU8y
         jBsKz/kLx4XVHV8g0Nfz4YtOdsQufngrQkOZF8gzkVkxeKOSa0y3EK5iGkAqQtffqOi5
         wa5DLevpPERZfVTbzXiZTJoNKQOZR8GQpO5/A=
MIME-Version: 1.0
In-Reply-To: <201103081035.24459.Martin@lichtvoll.de>
References: <201103051510.35057.Martin@lichtvoll.de>
	<201103062020.21959.Martin@lichtvoll.de>
	<AANLkTinhx12_HvDq3Mp7xrkrCez90pNiSuh7KrJAmFXp@mail.gmail.com>
	<201103081035.24459.Martin@lichtvoll.de>
Date: Tue, 8 Mar 2011 19:40:58 +1000
Message-ID: <AANLkTim8kRi8twRJmAZRQs6WhJin8cMMp70mBV+cpLQX@mail.gmail.com>
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks
 up hard when using desktop cube of kwin
From: Dave Airlie <airlied@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 7:35 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Its rainy again in Sevilla...
>
> Am Sunday 06 March 2011 schrieb Dave Airlie:
>> > I verified this. Lockup happens with 2.6.38, last one tested
>> > rc8-gfb62c00, but not with 2.6.37 with exactly same userspace.
>> > Needed to try the effect several times, as this time the lockup with
>> > 2.6.38 only happened shortly after the second activation of the
>> > effect.
>>
>> Hmm, can you attach Xorg logs from both?
>
> Attached. I have dmesgs available as well. Both kernels are mainly
> upstream. The 2.6.37 contains some recursive mtime patches from Jan for
> Ext3/4 that are very likely unrelated. For 2.6.38 I am testing too
> hibernation patches from Raphael, but the lockup also happened with a
> plain vanilla 2.6.38 one before.
>
>> I'm guessing its either pageflipping or a later kernel allowing some
>> feature of mesa to be used.

Okay can you try using an xorg.conf with Option "pageflip" "false" set
in it for the radeon.

Dave.
