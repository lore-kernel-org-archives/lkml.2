Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0JKM0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:26:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60717 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0JKM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L6j2dv2tx/yspR/oZEnSaU6gsUcKgto1Sep7Jf3uECp7DFVI2qhPLZzKqO+GUjD7AH
         WuAsWM8RCsNIyeigr+od2EfEWPAWz8K22/tmqV4e8l9cG5JWaVvow9dXV/P8PKa7EnQm
         RChm7VnEFZgkzK3RM2BM539aJ8vzeVb+p7F0k=
Message-ID: <4CB30266.1010706@gmail.com>
Date: Mon, 11 Oct 2010 13:26:14 +0100
From: Kieran Bingham <kieranbingham@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 11/16] pramfs: ACL management
References: <4CB1EAD8.2030206@gmail.com>
In-Reply-To: <4CB1EAD8.2030206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/10/2010 17:33, Marco Stornelli wrote:
> From: Marco Stornelli<marco.stornelli@gmail.com>
>
> ACL operations.
>
> Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/fs/pramfs/acl.c linux-2.6.36/fs/pramfs/acl.c
> --- linux-2.6.36-orig/fs/pramfs/acl.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/acl.c	2010-09-14 18:49:52.000000000 +0200
> @@ -0,0 +1,418 @@
> +/*
> + * FILE NAME fs/pramfs/acl.h
Found another one :)
FILE NAME != acl.h ...
--
KB
