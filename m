Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1BJOqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:46:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61345 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1BJOqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:46:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AN/S8Qel2UZIIJGNUJ7Y6SMS25UuIzbQ5VAnOjKJybChkK3VNb7gvQKrNtXEok1uEV
         i0vf979JuKnmogK8C8wDCKpeKQqxvs3kPU/lHN8ZW42EWIsqhBAXQUoFrZqX15u7pQw1
         o2+Mfbr2f3H+tnb3Zw2bDHURYWo1COPV+3wAQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTim54zTKwhTEKF-ppq-nbtPRAYRvxH3YL0RJ4Vuc@mail.gmail.com>
References: <46685.88.65.119.194.1297295587.squirrel@88.65.119.194>
 <AANLkTikHbJ+x0nEvdXQpzADwT3XfJNqR6O_WzaEtFWnh@mail.gmail.com>
 <AANLkTin1q=KP5xmj5mzEwOfHsMf=Mz4Ts1EbpGzJPcQX@mail.gmail.com> <AANLkTim54zTKwhTEKF-ppq-nbtPRAYRvxH3YL0RJ4Vuc@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 10 Feb 2011 22:46:24 +0800
Message-ID: <AANLkTi=k3D=1qwBX4E2rmo3pAun0BtBXZVG5mGwA74Y8@mail.gmail.com>
Subject: Re: [PATCH]ARM: mmp: add Trizeps6 board support
To: Yupeng Schneider <yupeng.schneider@googlemail.com>
Cc: yupeng.schneider@ipms.fraunhofer.de,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> AC97+UCB1400: Sound and Touchscreen is ok. The related pxa2xx-ac97 files
> have to be modified, the changes are not in this patch. If u want, i can
> patch them later too.
>

If it doesn't create a building regression, you can submit the patches
later. For completeness, you may want to do this as a whole though,
and CC Mark Brown <broonie@opensource.wolfsonmicro.com> and
Liam Girdwood <lrg@slimlogic.co.uk> for the sound related patches.

Thanks
