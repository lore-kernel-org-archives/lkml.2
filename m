Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0D1Sgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:36:53 -0400
Received: from kroah.org ([198.145.64.141]:38323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab0D1Sgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:52 -0400
Date: Wed, 28 Apr 2010 11:28:33 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 11/13] drivers/staging/vt6655: Hoist assign from if
Message-ID: <20100428182833.GF8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <8628ca12402a0806eebb7fee9c8cb980e0448401.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628ca12402a0806eebb7fee9c8cb980e0448401.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:17:05PM -0700, Joe Perches wrote:
> @@ -361,7 +362,8 @@ typedef struct tagDEVICE_TD_INFO{
>  /*
>  static inline PDEVICE_TD_INFO alloc_td_info(void) {
>      PDEVICE_TD_INFO  ptr;
> -    if ((ptr = kmalloc(sizeof(DEVICE_TD_INFO),GFP_ATOMIC))==NULL)
> +    ptr = kmalloc(sizeof(DEVICE_TD_INFO),GFP_ATOMIC);
> +    if (ptr==NULL)

Same issue again...
