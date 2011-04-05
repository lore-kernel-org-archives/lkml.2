Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1DEHha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:37:30 -0400
Received: from kroah.org ([198.145.64.141]:46422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1DEHhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:37:21 -0400
Date: Mon, 4 Apr 2011 22:52:45 -0700
From: Greg KH <greg@kroah.com>
To: Ronald Kasl <rkasl@computer.org>
Cc: gregkh@suse.de, arun.thomas@gmail.com, darren.armstrong85@gmail.com,
        mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: comedi: fix coding style / spaces
Message-ID: <20110405055245.GA557@kroah.com>
References: <1284409861-3446-1-git-send-email-rkasl@computer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284409861-3446-1-git-send-email-rkasl@computer.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:31:01PM -0400, Ronald Kasl wrote:
> This is a patch to the ssv_dnp.c file that fixes up the extra space warning
> found by the checkpatch.pl tool
> 
> Signed-off-by: Ronald Kasl <rkasl@computer.org>
> ---
>  drivers/staging/comedi/drivers/ssv_dnp.c |   40 +++++++++++++++---------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
> index 526de2e..cb72436 100644
> --- a/drivers/staging/comedi/drivers/ssv_dnp.c
> +++ b/drivers/staging/comedi/drivers/ssv_dnp.c
> @@ -1,24 +1,24 @@
>  /*
> -    comedi/drivers/ssv_dnp.c
> -    generic comedi driver for SSV Embedded Systems' DIL/Net-PCs
> -    Copyright (C) 2001 Robert Schwebel <robert@schwebel.de>
> -
> -    COMEDI - Linux Control and Measurement Device Interface
> -    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
> -
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> -
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> -
> -    You should have received a copy of the GNU General Public License
> -    along with this program; if not, write to the Free Software
> -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +comedi/drivers/ssv_dnp.c
> +generic comedi driver for SSV Embedded Systems' DIL/Net-PCs
> +Copyright (C) 2001 Robert Schwebel <robert@schwebel.de>

Ick, no, don't indent like this, keep the leading spaces please.

This patch isn't needed at all :(
