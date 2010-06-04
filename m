Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0FDErX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:47:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60418 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0FDErW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gCekVo9dvJMuzahSBTQaQ2y+Zc+9qPjxBpfrn/YABJ1O1FUhNDBzYlB/Esp7mNT0OB
         4zHY5CFj9uM+cJCnpbKiaG2/7ca81wzFcvFJz0ssHyrXHoACEsWvoZrRNB2qGb3mn8bL
         iNJJPR0tpGHWwqoTyQlBo6sS33ulOG9r50RTM=
Date: Fri, 4 Jun 2010 12:51:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: alan <alan@clueserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
Message-ID: <20100604045118.GC5167@cr0.nay.redhat.com>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 08:10:30PM -0700, alan wrote:
>Missed adding the actual segfault message:
>
>  LD      drivers/usb/built-in.o
>  LD      drivers/built-in.o
>  LD      vmlinux.o
>  MODPOST vmlinux.o
>/bin/sh: line 1: 20665 Segmentation fault      (core dumped)
>scripts/mod/modpost -o
>/home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
>make[1]: *** [vmlinux.o] Error 139
>make: *** [vmlinux.o] Error 2
>
>I have looked at the gcc 4.4.4 changelog and I can't see anything
>that should cause this.
>

Hmm, you need to find which program segfaults here.

What does 'file the_core_file_your_got' say?
