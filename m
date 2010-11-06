Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0KFNNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 09:13:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65290 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0KFNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 09:13:05 -0400
Date: Sat, 6 Nov 2010 13:12:58 +0000
From: James Hogan <james@albanarts.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16 v2] pramfs: super block operations
Message-ID: <20101106131257.GB13522@gandalf.local>
References: <4CD51847.20306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CD51847.20306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 06, 2010 at 09:56:39AM +0100, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Super block operations.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/fs/pramfs/super.c linux-2.6.36/fs/pramfs/super.c
> --- linux-2.6.36-orig/fs/pramfs/super.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/super.c	2010-09-25 14:09:47.000000000 +0200
<snip>
> +	pram_dbg("max name length %d\n", PRAM_NAME_LEN);

I get a warning on this line that could be avoided:

fs/pramfs/super.c: In function ‘pram_init’:
fs/pramfs/super.c:308: warning: format ‘%d’ expects type ‘int’, but
argument 2 has type ‘long unsigned int’

Cheers
James
