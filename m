Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1CJAgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:36:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32874 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1CJAgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:36:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xgi7i5qTQum+pzC56NLonYdsFxc//8Yp0H0KhCbI8KQgP1GWMah6HX+1MJXq+dgkQ8
         Q2918uts6zYN4TfasJLE4ovFxMVRw8P9bTv1ewt7PMit98lEB3MkHDTALob1MzRAaT0R
         NNyavDq5u0nntzAbprw2PyupUw2qVexvmLuU0=
MIME-Version: 1.0
In-Reply-To: <20110309100055.GB6923@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com> <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com> <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com> <20110309100055.GB6923@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 9 Mar 2011 19:35:48 -0500
Message-ID: <AANLkTinhm3t5TRRXnArzA=H23JOsAMCDwPUPp6aYi1gW@mail.gmail.com>
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for Analog
 Devices ADAU1701 SigmaDSP
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Cliff Cai <cliffcai.sh@gmail.com>, cliff.cai@analog.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 05:00, Mark Brown wrote:
> On Wed, Mar 09, 2011 at 03:25:05PM +0800, Cliff Cai wrote:
>> On Mon, Mar 7, 2011 at 8:29 PM, Mike Frysinger wrote:
>> > i dont see the issue here.  the firmware is *optional* and does not
>> > impair basic audio output.  further, the firmware is fully
>> > written/compiled/maintained by the end customer, just like the
>> > application.  which means there is no "magic" here -- the end customer
>> > is the wizard.
>>
>> it's a DSP,so firmware is not optional,actually there is default
>> internal program can be used
>> if no external firmware is downloaded,of cause, the internal program
>> is only used to test analog audio pass-through.
>
> If there is default firmware then even if it's not particularly useful
> the kernel should probably not *require* that additional firmware is
> provided during driver startup - the system may wish to wait until later
> in the boot to provide it, for example because it needs to mount media
> to get to the firmware or because it needs to do additional work to
> decide what firmware is required for the current system setup.

sorry, i was thinking this part was like the other ADI ones where the
DSP is there as an enhancement.  so many of my comments were tailored
towards that.

there shouldnt be any problem with us providing a stub firmware with
the kernel (in firmware/) that simply does a "pass through" or
whatever.
-mike
