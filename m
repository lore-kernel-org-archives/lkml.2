Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1HUTGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 15:06:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1HUTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 15:06:16 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: boot fails if x2apic is enabled unless efishell is used
Date: Sun, 21 Aug 2011 21:06:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110816210811.GA3331@breakpoint.cc>
In-Reply-To: <20110816210811.GA3331@breakpoint.cc>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212106.12427.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 16 sierpnia 2011 o 23:08:11 Sebastian Andrzej Siewior wrote:
> This is Intel i7 Sandy bridge on Asrock Z68 Pro3-M.
> 
> EFI -> GRUB -> Kernel -> crash
> EFI -> efishell -> GRUB -> Kernel -> works
> 

Old kernels (eg. 3.0.0, or 2.6.39) work OK?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
