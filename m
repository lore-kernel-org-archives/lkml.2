Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032383Ab2COXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:18:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64700 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032074Ab2COXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:18:21 -0400
Date: Thu, 15 Mar 2012 16:18:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120315231817.GA26440@kroah.com>
References: <4F626794.7000402@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F626794.7000402@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:05:08PM +0100, Markus Franke wrote:
> This patch adds a 1-wire slave device driver for the DS28E04-100.
> 
> It applies to the current linux kernel git tree.
> 
> Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>
> ---
>  drivers/w1/slaves/Kconfig      |    7 +
>  drivers/w1/slaves/Makefile     |    1 +
>  drivers/w1/slaves/w1_ds28e04.c |  458
> ++++++++++++++++++++++++++++++++++++++++

Your email client munged the patch to be line-wrapped and added an extra
space at the beginning of each line, making this impossible to apply.

Also, please cc: the w1 maintainer for patches like this, I need his ACK
before I can accept them.

care to try again?

greg k-h
