Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1GaLGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 07:06:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64291 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1GaLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 07:06:45 -0400
Date: Sun, 31 Jul 2011 15:06:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110731110641.GG2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> Hello,
> 
> I'm seeing those kernel message when resuming:
> 
> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> [  524.973288] Do you have a strange power saving mode enabled?
> [  524.973289] Dazed and confused, but trying to continue
> 
> I don't know if it's important or not because the system seems to work
> after but maybe it worths to report
> 

Hi Francis, cpu please?

	Cyrill
