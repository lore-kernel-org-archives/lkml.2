Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546Ab0FKTqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:46:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40726 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab0FKTqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Su7sbrMSytdEhjQ3YdCumNaq/yDcqKG8ZYBAMcfBzAYwiDDE2sb3hrwQHVWeWQueOx
         6M4Mg5AIS5FadVeA4wgR6g9ZCj5Eed0W8ipP6CBxGTvlDJEW90PO3Z3m7hc+g5fGw9ce
         T53E7U/1lgAiv0XSsj+2NGi2LitKa+mnmH4gU=
MIME-Version: 1.0
In-Reply-To: <1276237773.1556.507.camel@Joe-Laptop.home>
References: <1276237773.1556.507.camel@Joe-Laptop.home>
Date: Fri, 11 Jun 2010 12:46:08 -0700
X-Google-Sender-Auth: TPS_k6dx5eB51mfju6PnqYaDxRo
Message-ID: <AANLkTilHvo4aJPLiGJywWE3EvXtYO5r9BEuoqsbYX4vt@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/e1000/e1000_main.c: Fix message logging 
	defect
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Emil Tantilov <emil.s.tantilov@intel.com>, netdev <netdev@vger.kernel.org>,
       e1000-devel <e1000-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 23:29, Joe Perches <joe@perches.com> wrote:
> commit 675ad47375c76a7c3be4ace9554d92cd55518ced
> removed the capability to use ethtool.set_msglevel to
> control the types of messages emitted by the driver.
>
> That commit should probably be reverted.
>
> If not, then this patch fixes a message logging defect
> introduced by converting a printk without KERN_<level>
> to e_info.
>
> This also reduces text by about 200 bytes.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Thanks Joe.  I have added the patch to my queue.
