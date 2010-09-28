Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0I1UHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:07:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0I1UHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IJnb94q2azB2LfFr8mvHdWo0HKJLZaVHOAdeNlDuhcSuqB02slX5z8Y7do130zFYPn
         jb2C7cBi1v2pN3+eyi5Vc5X6bWCi01w1KQYCBPkC5SGlp9tPL29tAjT+7GAipA9GeO89
         MbdczmY27GK3jbgijyxKdomAJkbvXvx36Y+nE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1009281624100.11083@axis700.grange>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com>
	<AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
	<Pine.LNX.4.64.1009281624100.11083@axis700.grange>
Date: Tue, 28 Sep 2010 13:07:40 -0700
Message-ID: <AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
From: Raymond Liu <raymondliu3linux@gmail.com>
To: Ben Gamari <bgamari@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben and Guennadi,

Really appreciate your inputs.

For temporarily short term purpose (we already had a driver but it did
not fit into any of these you mentioned), what is the process we
should follow to make it an "open source"?

Thanks,
Raymond



On Tue, Sep 28, 2010 at 7:29 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Sun, 26 Sep 2010, Raymond Liu wrote:
>
>> Hi,
>>
>> My company is working on the Linux HDMI open source driver for our
>> chipsets (with audio/video/CEC controls).  Is there any similar
>> project ongoing for this kind of driver in Linux community?  Who
>> should I contact with for this?
>
> I think, it depends on what kind of hardware it is, resp, what kind of a
> driver you'd like to have. Best fit for HDMA, IMHO, is a KMS driver. If,
> however, that's too much for you and you only want a framebuffer driver,
> you might want to have a look, how HDMI support has been recently added to
> the sh_mobile_lcdcfb.c driver - both video and audio. Try to begin here
> http://search.gmane.org/?query=hdmi&group=gmane.linux.ports.sh.devel and
> look for patches from Morimoto-san and myself. But HDMI with framebuffer
> is not a very elegant combination, so, if you can, try KMS.
>
> Good luck
> Guennadi
>
>>
>> Thanks,
>> Raymond Liu
>>
>> P.S. I wish to be personally CC'ed the answers/comments posted to the
>> list in response to my posting.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
