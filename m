Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1GRUwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:52:46 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:50878 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1GRUwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:52:45 -0400
Date: Mon, 18 Jul 2011 23:52:40 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 1/2] lib: make _tolower() public
Message-ID: <20110718205239.GA3543@p183.telecom.by>
References: <CACVxJT-0=cpieN52g2LZ1W+PPmpL-kR9nHCk53bBSR=Js1cbRA@mail.gmail.com>
 <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ebc58c68603c4a5d084e77d355b77dc72225a3f.1310993826.git.andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctype.h is better place, otherwise

Acked-by: Alexey Dobriyan <adobriyan@gmail.com>

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -189,6 +189,12 @@ NORET_TYPE void complete_and_exit(struct completion *, long)
>  	ATTRIB_NORET;
>  
>  /* Internal, do not use. */
> +static inline char _tolower(const char c)
> +{
> +       return c | 0x20;
> +}
