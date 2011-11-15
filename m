Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1KOURu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:17:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab1KOURt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:17:49 -0500
From: "Sergey V." <sftp.mtuci@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: radeon/kms: black screen when loading radeon with modeset=1
Date: Wed, 16 Nov 2011 00:17:42 +0400
User-Agent: KMail/1.13.6 (Linux/3.0.6-sftp+; KDE/4.5.5; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201111152305.09451.sftp.mtuci@gmail.com> <CADnq5_Mu4pLxTpdOYDBaqf2d3XsZC1bH-pBVZ_dA0WGj6EtwAg@mail.gmail.com>
In-Reply-To: <CADnq5_Mu4pLxTpdOYDBaqf2d3XsZC1bH-pBVZ_dA0WGj6EtwAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111160017.43361.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 of November 2011 23:21:10 Alex Deucher wrote:
> On Tue, Nov 15, 2011 at 2:05 PM, Sergey V. <sftp.mtuci@gmail.com> wrote:
> > Kernel from Linus tree, HEAD at 7f80850d3f9fd8fda23a317044aef3a6bafab06b
> >
> > Loading radeon module with modeset=1 causes black screen.
> >
> > Usually it happens at boot time, but if run kernel with radeon.modeset=0 
then
> > `rmmod radeon; modprobe radeon modeset=1` I can get dmesg over ssh (thanks 
to
> > glisse from #radeon for help).
> 
> Fixed with this patch:
> http://lists.freedesktop.org/archives/dri-devel/2011-November/016498.html
> 
> Alex
> 

Thank you! I tested the patch and it helped.
