Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0GBB1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 21:27:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46414 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0GBB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 21:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P78mkVk4FDwbSSspINF701B+SQMYLQEW/I1DeyOgwT5NWT9pra9k3YjZOY3ERbIGxr
         /MJ0hC6PfVSJp2gHkz/2qN3YoWya8WeZRNBuAntHWhyFgnG1U2AETOfT7mjqEok4MYdC
         TlbhNwWBKIBqYyiojWBknOB0Su4pbFnIV3CdY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1007020143560.9535@bwv190.internetdsl.tpnet.pl>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<Pine.LNX.4.64.1007020143560.9535@bwv190.internetdsl.tpnet.pl>
Date: Thu, 1 Jul 2010 18:27:37 -0700
Message-ID: <AANLkTilj4wEo0W3hjR3JtGYbY2yoKAAIMQUA0LOc9-Rz@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought Intel shelved Larrabee.

~ C.

On Thu, Jul 1, 2010 at 4:51 PM, Piotr Gluszenia Slawinski
<curious@bwv190.internetdsl.tpnet.pl> wrote:
>> We are going to start to see a number of companies in the embedded
>> space submitting 3D drivers for mobile devices to the kernel. I'd like
>> to clarify my position once so they don't all come asking the same
>> questions.
>
> one of options for future would be equipping gpu's with additional
> processing force, allowing it to run whole Xorg on it's own,
> and just communicate with rest of machine via shared memory window (so
> visible as 'hardware X server' from systems standpoint),
>
> option which allows both - closing 'source' of gpu , and taking
> off burden of development for closed, once-use-throwaway
> devices from Xorg and kenel crew.
>
> also port of Xorg on GPUs itself allows skipping a lot of features
> of kernel, and OS itself (it doesn't to be based on linux afterall)
> allowing much more robust performance, and skipping common bottlenecks
> (sharing irq's , scheduling, etc)
>
> but this route needs to be considered by hardware vendors themselves.
>
> --
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>



-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
