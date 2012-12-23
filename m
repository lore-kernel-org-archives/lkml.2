Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2LWRnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 12:43:25 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:50160 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LWRnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 12:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
References: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Dec 2012 09:43:01 -0800
X-Google-Sender-Auth: -CLorWCJspomaDOJD_QymUcak-E
Message-ID: <CA+55aFzXShkx-QCohNABW+S=43f9K8iyy=vFyGPpG7Tx7=VrgA@mail.gmail.com>
Subject: Re: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
To: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörg - does current git work for you? It has a patch from Rafael that
just reverts the insane error code, and fixed something very similar
for him.

(I just pushed out, so it might take a few minutes to mirror out to
the public sites).

              Linus

On Sun, Dec 23, 2012 at 8:46 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
> They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
> (system-sound),
> System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
> and must be killed.
