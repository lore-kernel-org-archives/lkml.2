Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0KVUwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:52:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0KVUw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fXUHYtqYdsVyAbEyphetqGpi2Sy4+6/Y55o39Jk7EMrD/NsZYYvO3aOxEXq6Gg6Bk5
         oN3JcB3pgGxVij8CKo5X42pVs/vohyG7bBVlvZa7WgbuA8D6O3CoCbafd3F95b6M81GL
         Y8yynWMuiYDPiC0snKXYi9KyARWx4pxjIiQro=
MIME-Version: 1.0
In-Reply-To: <20101122191831.GG4340@kroah.com>
References: <20101122191831.GG4340@kroah.com>
Date: Mon, 22 Nov 2010 22:52:26 +0200
Message-ID: <AANLkTin2Wjfyo+pHBXR97bArS3=sSGmi5DCL8kapavSU@mail.gmail.com>
Subject: Re: Linux 2.6.36.1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 9:18 PM, Greg KH <gregkh@suse.de> wrote:
> I'm announcing the release of the 2.6.36.1 kernel.
>
> All users of the 2.6.36 kernel series must upgrade.
>
> The updated 2.6.36.y git tree can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
> and can be browsed at the normal kernel.org git web browser:
>        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=summary
>
> thanks,

This one is missing
0e7adbe ALSA: hda - Disable sticky PCM stream assignment for AD codecs

Otherwise sound doesn't work on AD codecs.

-- 
Felipe Contreras
