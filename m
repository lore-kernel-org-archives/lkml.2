Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0KIU1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:27:12 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41138 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0KIU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:27:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OHtM1LO9WllEBS0N4NXtw9SVJO4nyShS6f2hTm18huFTgI2ntvXvtXCNFYuwsIjO8W
         Rsnu+DAxPUWe5PC84p4VMrEINZ76lsEl6yOlr8pDzZIjVOVO5TaqRfwatv31iicfFICp
         S6Ln/tJFS7q/XgAEbaFc4Ddj/z/uU2528Uup8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Paul Rolland (=?utf-8?b?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
Subject: Re: [2.6.37-rc1] drm:i195 errors
Date: Tue, 9 Nov 2010 21:26:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
In-Reply-To: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011092126.59432.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 2 listopada 2010 o 15:58:13 Paul Rolland wrote:
> Hello,
> 
> I was previously running 2.6.36, without noticing any messages related to
> i915/DRM, but now I can see some :
> 
> Nov  2 14:21:53 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR*
> Attempting to mmap a purgeable buffer
> 
> and also :
> 
> Nov  2 15:45:35 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR*
> fixme: max PWM is zero.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22542
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
