Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab2JLBzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:55:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32783 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550Ab2JLBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <507710EA.1070900@shealevy.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
	<4FE37194.30407@redhat.com>
	<4FE8B8BC.3020702@iki.fi>
	<4FE8C4C4.1050901@redhat.com>
	<4FE8CED5.104@redhat.com>
	<20120625223306.GA2764@kroah.com>
	<4FE9169D.5020300@redhat.com>
	<CA+55aFwi2F1PYv39FxTKz1zu2tFqVDSAAxeSRW1BVK+==5H-6g@mail.gmail.com>
	<507710EA.1070900@shealevy.com>
Date: Fri, 12 Oct 2012 09:55:18 +0800
Message-ID: <CACVXFVN9U1v160guSrn=Gr+SyKzANCpzBFfxu20QiNHuZ5jTng@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
From: Ming Lei <tom.leiming@gmail.com>
To: Shea Levy <shea@shealevy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 2:33 AM, Shea Levy <shea@shealevy.com> wrote:

>
> FWIW (and probably that's not much), the NixOS[0] distro doesn't currently
> use /lib/firmware. There is no /lib directory by default on NixOS, instead
> we create a new symlink tree representing the current system on each system
> change and symlink /run/current-system to that tree. We currently build
> udev/systemd with the --with-firmware-path=/run/current-system/firmware
> configuration-time option, but we also patch module-init-tools and kmod to
> respect the $MODULE_DIR env var and may do the same for firmware in the
> future. The way we do things has significant advantages (or at least we like
> to think so), but we already have exceptions for /bin/sh and /usr/bin/env,
> so I suspect we'll probably add in /lib/firmware if this functionality moves
> into the kernel.

The kernel parameter for customizing firmware search path will be added, so
you use can pass your search path from kernel command too.

Thanks,
-- 
Ming Lei
