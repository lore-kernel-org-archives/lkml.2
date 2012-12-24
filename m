Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2LXI5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:57:03 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41643 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2LXI5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:57:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121223183743.0400ac93@redhat.com>
References: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
	<20121223183743.0400ac93@redhat.com>
Date: Mon, 24 Dec 2012 09:56:59 +0100
Message-ID: <CADDKRnB4Qz6Qiy9SC6fspf39jUVOD4VSHY97pL_YVL8T+EVzig@mail.gmail.com>
Subject: Re: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/23 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Hi Jörg,
>
> Em Sun, 23 Dec 2012 17:46:07 +0100
> Jörg Otte <jrg.otte@gmail.com> escreveu:
>
>> With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
>> They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
>> (system-sound),
>> System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
>> and must be killed.
>>
>> With kernel 3.7 there are no problems.
>
> Do you have any other non-uvc device to test?

No I haven't.

Thanks, Jörg
