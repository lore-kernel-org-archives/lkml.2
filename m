Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0JKMYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:24:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55293 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0JKMYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F6nbkoZ7hdw4NPeqLnhZnvW5orBkvDi2tYimn+ELTmIL1bH8e7iiHWddNNy+8xT7DZ
         0QpRwdnifGoxIUftPMIjBTiTrjmqtxquNGIaQaj/WGorjeX0soF6ME4n9r6zAXXEiNIN
         4u3uOp/WLWIFfsgApyPuF2UgBhpxlJGdL4JFI=
Message-ID: <4CB301E4.40405@gmail.com>
Date: Mon, 11 Oct 2010 13:24:04 +0100
From: Kieran Bingham <kieranbingham@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 15/16] pramfs: test module
References: <4CB1EBDD.8050509@gmail.com>
In-Reply-To: <4CB1EBDD.8050509@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/10/2010 17:37, Marco Stornelli wrote:
> From: Marco Stornelli<marco.stornelli@gmail.com>
>
> Test module.
>
> Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/fs/pramfs/pramfs_test.c linux-2.6.36/fs/pramfs/pramfs_test.c
> --- linux-2.6.36-orig/fs/pramfs/pramfs_test.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/pramfs_test.c	2010-09-14 18:49:52.000000000 +0200
> @@ -0,0 +1,49 @@
> +/*
> + * FILE NAME fs/pramfs/namei.c
FILE NAME != namei.c
