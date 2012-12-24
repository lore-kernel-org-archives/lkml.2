Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2LXIwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:52:38 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49976 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2LXIwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:52:35 -0500
X-Greylist: delayed 57615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 03:52:35 EST
MIME-Version: 1.0
In-Reply-To: <CA+55aFzXShkx-QCohNABW+S=43f9K8iyy=vFyGPpG7Tx7=VrgA@mail.gmail.com>
References: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
	<CA+55aFzXShkx-QCohNABW+S=43f9K8iyy=vFyGPpG7Tx7=VrgA@mail.gmail.com>
Date: Mon, 24 Dec 2012 09:52:34 +0100
Message-ID: <CADDKRnAaBOEPwgboWBAs-Wum4z7Ez7SRPruMeHjRwF6q+95urQ@mail.gmail.com>
Subject: Re: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes it works, incl. usb-camera. I am now at:

637704cbc95c02d18741b4a6e7a5d2397f8b28ce Merge branch
 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux

Thanks, Jörg


2012/12/23 Linus Torvalds <torvalds@linux-foundation.org>:
> Jörg - does current git work for you? It has a patch from Rafael that
> just reverts the insane error code, and fixed something very similar
> for him.
>
> (I just pushed out, so it might take a few minutes to mirror out to
> the public sites).
>
>               Linus
>
> On Sun, Dec 23, 2012 at 8:46 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
>> With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
>> They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
>> (system-sound),
>> System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
>> and must be killed.
