Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0HQNUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:20:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0HQNUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:20:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: piotr@hosowicz.com
Subject: Re: ioctl definition - has it changed recently?
Date: Tue, 17 Aug 2010 15:18:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <4C67023D.6050603@example.com> <4C68EFE8.20202@example.com> <4C6A8A73.1070003@example.com>
In-Reply-To: <4C6A8A73.1070003@example.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171518.14032.arnd@arndb.de>
X-Provags-ID: V02:K0:r+6qv4A+ozY5HDBs0Z2rupEbM6kP70nOSC6WRacONOe
 MgtRqXeoj2WVo5azE46+jBxl2+S5fKrP6mYUk7AdTsQzkttjB7
 MvmwfZbX9llt90Bwb0SrAF7n5O4flOBwZcPxVGz5MLx4H5X9/R
 yvx9eaRIOwUZS62AwJCCQZvAwFJB5UDHf12W2D6Q9z+QNahFPA
 +5ixrpMGL5ecxo2mSzb8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Piotr Hosowicz wrote:
> >> Just take a look at all the other patches that went into the
> >> kernel to do this for other drivers.
> 
> I do not know how to find them. :-(

git log -p -S"unlocked_ioctl"

> > It seems different. How to change it? Now it works, I built it without
> > your remarks, exactly how I described on my blog:
> >
> > http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/
> 
> Ok, as I wrote the prototypes differ. What should I do with the inode 
> parameter?

It's normally not needed.

If you do need it, use file->f_path.dentry->d_inode.

	Arnd
