Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2DFEwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 00:52:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55628 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2DFEwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <CANudz+uhw4LZ4EoDvp_eC2K23=Qm_ACPpM8TRq5p0t9=idKcSg@mail.gmail.com>
References: <CANudz+uhw4LZ4EoDvp_eC2K23=Qm_ACPpM8TRq5p0t9=idKcSg@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Fri, 6 Apr 2012 11:52:03 +0700
Message-ID: <CAGdaadbywdKu_8H5+MLMz_Sp_VC+JoUaw0-w-EiOqMGkTA30DA@mail.gmail.com>
Subject: Re: Some questions about high memory
To: loody <miloody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

On Fri, Apr 6, 2012 at 09:19, loody <miloody@gmail.com> wrote:
> hi all:
> I am trying to write a driver for my block device which dma support
> high memory copying.
> I have register my device as "blk_bounce_any".
> But my driver cannot see block layer pass high memory to me so far.

perhaps because you need to kmap them first?

BTW, is it 32 bit or 64 bit Linux kernel?

> Is there any user/kernel test program which will purposely send high
> memory for driver to use?
> or is there any flag when opening a file in user mode that will use high memory?

I recheck mmap and mmap manual page and I found none of such flag

-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
