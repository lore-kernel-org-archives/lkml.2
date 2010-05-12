Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0ELJUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:20:50 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56942 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0ELJUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:20:49 -0400
Date: Wed, 12 May 2010 11:20:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Arce, Abraham" <x0066660@ti.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] EEPROM: Header file cleanup
Message-ID: <20100512112046.2a46b3a8@hyperion.delvare>
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
References: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 13:08:15 -0500, Arce, Abraham wrote:
> Change eeprom.c header file to format as in conventions
> 
> Signed-off-by: Abraham Arce <x0066660@ti.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  drivers/misc/eeprom/eeprom.c |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> index f939ebc..fffa2e8 100644
> --- a/drivers/misc/eeprom/eeprom.c
> +++ b/drivers/misc/eeprom/eeprom.c
> @@ -1,24 +1,24 @@
>  /*
> -    Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> -			       Philip Edelbrock <phil@netroedge.com>
> -    Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> -    Copyright (C) 2003 IBM Corp.
> -    Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
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
> -*/
> + * Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> + *                           Philip Edelbrock <phil@netroedge.com>
> + * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> + * Copyright (C) 2003 IBM Corp.
> + * Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
>  
>  #include <linux/kernel.h>
>  #include <linux/init.h>


-- 
Jean Delvare
