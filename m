Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2GQRgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:36:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2GQRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:34:55 -0400
Date: Tue, 17 Jul 2012 10:34:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: MAX77693: Add extcon-max77693 driver to support
 Maxim MAX77693 MUIC device
Message-ID: <20120717173451.GA31323@kroah.com>
References: <1342499308-5505-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342499308-5505-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 01:28:28PM +0900, Chanwoo Choi wrote:
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Really?  Any later version?  Ok, but please be sure of this.

I'm waiting for the "GPLv42" version that says something really strange
and burns everyone who ever put this in their code...

thanks,

greg k-h
