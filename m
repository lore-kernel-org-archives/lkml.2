Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0K3PtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:49:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0K3PtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gkJKPpUeSVPG6sogyHGI3RnsyT1XzJ5TrYR92VKeUB8jj/TLvpEWInXI0e6NMRyVS9
         KY+6hfGS2mwLkR+1kJH+jj4GXbRbGsY6SBnj4gGAfgCDkNFDuxE615Vp1/X9iROADcbH
         9ivjw3/DQWzEiTgu5n5GXSgte+Y4J0T9Kd3VI=
MIME-Version: 1.0
In-Reply-To: <006601cb9024$c9369110$5ba3b330$%kim@samsung.com>
References: <008201cb8c58$363980e0$a2ac82a0$%kim@samsung.com>
	<4CEFFBE6.9040909@gmail.com>
	<006601cb9024$c9369110$5ba3b330$%kim@samsung.com>
Date: Tue, 30 Nov 2010 17:49:07 +0200
Message-ID: <AANLkTinuYg2LzwZJUnpT0-b3Gi+vOJr-_fi4o874DAFG@mail.gmail.com>
Subject: Re: [GIT PULL] Samsung fixes for 2.6.37-rc4
From: Darius Augulis <augulis.darius@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Kukjin,

could you please both find out who must 'handle' it?
Do you think it's normal to force people to ping you for the same four
lines patch for 4 months or more?
I think, it's at least not optimal and not good for kernel development process.

thanks,
Darius


On Tue, Nov 30, 2010 at 2:23 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Darius Augulis wrote:
>>
>> Hi Kukjin,
>>
> Hi,
>
>> you have missed "serial: samsung: fix device name" again.
>> Please, don't forget to add it to your tree, better do it right now.
>> Perhaps it's fifth or sixth time when remind about that...
>>
> I remember, I've replied about that like following.
> Maybe you missed...
>
> ---
>> you have missed "serial: samsung: fix device name" which is hanging here
>> for a long time and was decided to merge in 2.6.37-rc1.
>> Please, pick it up.
>>
> Hmm...I thought it should be handled by Ben Dooks at that time.
>
> Anyway, as Ben said, I'm thinking it should be sent upstream when merge
> window
> even though have missed it in the last merge window.
>
> However, if Ben is ok to merge this during 37-rc, will merge it into
> s5p-fixes-
> for-linus for 37-rc.
> ---
>
> But I still thinking it should be handled by Ben Dooks...

handle what? You have Ben ack to merge it. I'm confused how 'optimal'
is development process when have to ping the same people for the same
four lines patch for 4 months. You both  Do you think I really have to
ask help for arm, serial or linux-stable maintainers to 'hadle' this?
Because I gave up believing it's possible to do by samsung
maintainers.

>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
