Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1CIV17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1CIV16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:27:58 -0500
Date: Wed, 9 Mar 2011 13:26:43 -0800
From: Greg KH <gregkh@suse.de>
To: Vinay Sawal <vinaysawal@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Bcmnet: fixed checkpatch script issues
Message-ID: <20110309212643.GA27747@suse.de>
References: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 12:50:01PM -0800, Vinay Sawal wrote:
> Fixed all issues reported by checkpatch script on this file.
> 
> Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
> ---
>  drivers/staging/bcm/Bcmnet.c |   51 +++++++++++++++++++++++++++++------------
>  1 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
> index a6ce239..4e38a76 100644
> --- a/drivers/staging/bcm/Bcmnet.c
> +++ b/drivers/staging/bcm/Bcmnet.c
> @@ -1,3 +1,23 @@
> +/*
> +    bcm/Bcmnet.c
> +    Bcm network driver
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.

Why "or any later version"?  Are you allowed to relicense the code here?

> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

Are you willing to track the office movements of the FSF for the next 40
years and send patches updating the address?  If not, NEVER, include
this paragraph, it's pointless.

Anyway, as others stated, this is not acceptable for a "fix checkpatch
warnings" type of patch, please redo it.

thanks,

greg k-h
