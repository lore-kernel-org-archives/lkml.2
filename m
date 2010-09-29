Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0I2T1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:27:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45972 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab0I2T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bAw3k7UHKHpWEcEZ5MGUPC3KfWcMF0EWlW+bM7SV3dHgziK3khHC6bZgQ+dJMO5ryo
         mgcd18uAiBRImJwCMP/CgcuyePopJ1Fwz4BmuxKnOLUTI5ipRMZsi1F40+HkNHhFPdho
         X0VeMgVsT60tQhyhSI2dYV5K7x5GFHCd0/Moo=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1009290115500.15162@axis700.grange>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com>
	<AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
	<Pine.LNX.4.64.1009281624100.11083@axis700.grange>
	<AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
	<Pine.LNX.4.64.1009290115500.15162@axis700.grange>
Date: Wed, 29 Sep 2010 12:27:11 -0700
Message-ID: <AANLkTinPAuqQa+KOLuaX3ZQO4NXuVoi=uWsofTiNXW04@mail.gmail.com>
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
From: Raymond Liu <raymondliu3linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ben Gamari <bgamari@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben and Guennadi,

Thanks again for these important inputs.  We had a much clear picture
about what we can do and what we should do with our OEMs on the driver
for open source at this point.

Thanks,
Raymond

On Tue, Sep 28, 2010 at 4:29 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 28 Sep 2010, Raymond Liu wrote:
>
>> Hi Ben and Guennadi,
>>
>> Really appreciate your inputs.
>>
>> For temporarily short term purpose (we already had a driver but it did
>> not fit into any of these you mentioned), what is the process we
>> should follow to make it an "open source"?
>
> Sorry, do not understand: if it didn't fit into any of these categories,
> what is it like? In any case, general instructions you find in the
> following files in your Linux kernel sources directory:
>
> Documentation/SubmitChecklist
> Documentation/SubmittingPatches
> Documentation/SubmittingDrivers
> Documentation/CodingStyle
>
> I know, it might seem a lot, but take a bit of time to look through them,
> not everything will be 100% relevant to each specific case, but do follow
> Documentation/CodingStyle and choose a suitable mailing list for your
> posts - this list (LKML) is too gneric for your questions, that's why
> you're getting so few to-the-topic replies.
>
> And I'm not sure what you mean by "temporarily short term purpose." As
> soon as your driver gets into the kernel, it is better, if it is designed
> to stay there for a longer time. It might not be perfect from the very
> first version, its functionality might be restricted, but for that little,
> that it does, it should already adhere to the kernel standards. You might
> also consider adding your driver under drivers/staging - if you're unable
> to follow the guidelines and want to give your driver more exposure to
> gradually fix it.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
