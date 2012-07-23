Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2GWPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:25:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40659 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2GWPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120705222429.43586868@europa>
References: <20120611231842.221bd738@europa>
	<20120705222429.43586868@europa>
Date: Mon, 23 Jul 2012 18:25:55 +0300
Message-ID: <CAJCn4U=pLjiLVW_TT+JN5G177dh4RUwg=vinjBrS4udChOyqoQ@mail.gmail.com>
Subject: Re: [bisected] nouveau: "Failed to idle channel x" after resume
From: Aioanei Rares <krnl.list@gmail.com>
To: Martin Nyhus <martin.nyhus@gmx.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:24 PM, Martin Nyhus <martin.nyhus@gmx.com> wrote:
>
> On Mon, 11 Jun 2012 23:18:42 +0200 Martin Nyhus wrote:
> > after resuming from suspend nouveau starts writing Failed to idle
> > channel x (where x is 2 or 3) to the log and X appears to stop and
> > then restart only to stop again. Starting Firefox after resuming
> > triggers the bugs every time, and bisecting leads to 03bd6efa
> > ("drm/nv50/fifo: use hardware channel kickoff functionality").
>
> Hi Ben,
> I'm still seeing this bug with the latest from Linus
> (v3.5-rc5-98-g9e85a6f) and linux-next (next-20120705).
>
> lspci output:
> 01:00.0 VGA compatible controller: nVidia Corporation G86 [GeForce
> 8400M GS] (rev a1)
>
> Sorry I haven't followed up on this earlier,
> Martin

I can confirm this with 3.5.0, Chromium and Arch Linux. It's a HP
Pavilion laptop with a G86 [GeForce 8400 M GS] video card .
Seems related to this bug:
http://lists.freedesktop.org/archives/nouveau/2011-January/007358.html
. If I can do anything else
to help, I will be glad to.
