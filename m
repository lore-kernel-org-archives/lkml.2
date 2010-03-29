Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0C2Joi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:44:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:56422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0C2Jo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:44:27 -0400
Date: Mon, 29 Mar 2010 11:44:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3 6/6] hid: add experimental access to PicoLCD device's
 EEPROM and FLASH
In-Reply-To: <20100324235835.0e7e1bcb@neptune.home>
Message-ID: <alpine.LNX.2.00.1003291142400.24576@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home> <20100324235835.0e7e1bcb@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Bruno Prémont wrote:

> +static ssize_t picolcd_debug_reset_open(struct inode *inode, struct file *f)
> +{
> +	return single_open(f, picolcd_debug_reset_show, inode->i_private);
> +}
> +

struct file_operations->open is supposed to return int (filedescriptor), 
not ssize_t.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
