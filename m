Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424Ab2J2SdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:33:17 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55936 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760414Ab2J2SdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:33:13 -0400
MIME-Version: 1.0
In-Reply-To: <20121029174100.GD3706@swordfish.minsk.epam.com>
References: <20121027160347.GB4771@swordfish>
	<508EBB1E.9060400@vflare.org>
	<20121029174100.GD3706@swordfish.minsk.epam.com>
Date: Mon, 29 Oct 2012 11:33:11 -0700
Message-ID: <CAPkvG_cX4x+WkY5A9ieD8VwQe+ROrvVBS1B19MGgQF4OfmQdrw@mail.gmail.com>
Subject: Re: [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs
 parameter (v2)
From: Nitin Gupta <ngupta@vflare.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 10:41 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
>   zram: handle mem suffixes in disk size zram_sysfs parameter
>
>   Use memparse() to allow mem suffixes in disksize sysfs number.
>   Examples:
>        echo 256K > /sys/block/zram0/disksize
>        echo 512M > /sys/block/zram0/disksize
>        echo 1G > /sys/block/zram0/disksize
>
>   Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>

FWIW,

Reviewed-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
