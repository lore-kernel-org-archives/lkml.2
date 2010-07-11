Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0GKSCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 14:02:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59185 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0GKSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 14:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=SRE4msrSVG31dR9LgkK+XjFzgfqOofx7ioJUYkoajpsbpZRLPwZM7gGNWQiwAFMeO8
         IU1hLZ7NBOz8LQkfgw+1SXn4Hgdn68Tg6LJfYuzrcdrP1MWpWQPubwpgdzWvn41iFjie
         fu7WOTpXBRi2TQpwaCj7iRHyKTpzg8rAL+LJk=
MIME-Version: 1.0
In-Reply-To: <20100711131640.GA3503@thunk.org>
References: <201007110918.42120.Martin@lichtvoll.de>
	<20100711131640.GA3503@thunk.org>
Date: Sun, 11 Jul 2010 21:02:36 +0300
Message-ID: <AANLkTimQsJPqLGwQ68Ldi-fEJaomPtnTOKcWMrk9Ye2K@mail.gmail.com>
Subject: Re: stable? quality assurance?
From: Anca Emanuel <anca.emanuel@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offtopic.

I'm using Ubuntu 10.04 and kernel 2.6.35-rc1 from kernel.ubuntu.com
Wonking fine (stable, but my webcam still not working).

Using this https://wiki.ubuntu.com/KernelTeam/GitKernelBuild tutorial
to compile the kernel. But no success (it finish the compile but no
deb packages).
I have done it from virtualbox some weeks ago, and grub can not mount.

Is there any tutorial how to build the kernel for Ubuntu 10.04 ?

Please test it yourself in (Ubuntu 10.04):
sudo cfdisk
result: Bad primary partition 1. (any kernel, any enviroment).
