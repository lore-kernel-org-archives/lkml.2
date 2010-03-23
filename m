Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0CWEG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:06:26 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43367 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0CWEGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:06:25 -0400
Date: Tue, 23 Mar 2010 13:05:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
       hskinnemoen@atmel.com
Subject: Re: [PATCH] uImage: Allow to specify MKIMAGE
Message-ID: <20100323040513.GB13417@linux-sh.org>
References: <20100320184907.8036.82488.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100320184907.8036.82488.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 08:49:07PM +0200, Paulius Zaleckas wrote:
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
> ---
> 
>  arch/arm/boot/Makefile          |    4 ++--
>  arch/avr32/boot/images/Makefile |    4 ++--
>  arch/blackfin/boot/Makefile     |    4 ++--
>  arch/microblaze/boot/Makefile   |    4 ++--
>  arch/sh/boot/Makefile           |    4 ++--
>  scripts/mkuboot.sh              |    1 +
>  6 files changed, 11 insertions(+), 10 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
