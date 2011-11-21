Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1KUOcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:32:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1KUOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAJJYPdkFpq+VJDyAP6dk3j-6YN+Ttu0ejByzEnr2HvXozYVXSg@mail.gmail.com>
References: <CAJJYPdkFpq+VJDyAP6dk3j-6YN+Ttu0ejByzEnr2HvXozYVXSg@mail.gmail.com>
Date: Mon, 21 Nov 2011 15:32:09 +0100
Message-ID: <CAJJYPdnfJwUEZWpKSfjf3xjzzyHoHLe1VONtVQ0N5uP8raYY5w@mail.gmail.com>
Subject: Re: WARNING: at drivers/gpu/drm/i915/intel_display.c:792
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: intel-gfx@lists.freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/21 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> My Xorg server on rawhide machine is giving me sudden X lockups with 3.1 kernel.
> There might be couple issue related together as rawhide is now using
> some experimental
> Xorg server - but the message from kernel is a bit scary - so
> reposting to lkml as well.
>
> xorg-x11-server-Xorg-1.11.99.1-6.20111109.fc17.x86_64
> git intel driver: 3b9479dc39d32fd97f80c1e5e0fac67d36ee5e40
> drm version (a bit older): 8d055890d90c3d92647e3d8b98d32630ef87c2c8
> (since current Fedora rawhide intel driver is so much broken it
> doesn't even start)
>


It's worth to mention - it happens also with kernel 3.0
and the latest updated libdrm  (ca4971292cf99e0063416cd1c3467af94637bf2b)
The processing of mouse event seems to be always mandatory
(i.e. it blacks LCD with some mouse movement).

Zdenek
