Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab2CZSjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:39:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2CZSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:43 -0400
Date: Mon, 26 Mar 2012 11:39:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120326183939.GA29332@kroah.com>
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
 <20120318214041.GA20521@ioremap.net>
 <4F6F7E37.5000209@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6F7E37.5000209@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 10:21:11PM +0200, Markus Franke wrote:
> Dear Greg,
> 
> have you received this patch? Just wondering because I have not
> heard something about this anymore from your side.
> Please do also have a look at
> 
> [PATCH 2/2] w1: Disable irqs during 1-wire bus operations, extend
> 1-wire reset pulse
> 
> Both patches have already been signed by Evgeniy Polyakov.

They are in my queue to apply after 3.4-rc1 is out as they came in after
the merge window closed for my trees.

thanks,

greg k-h
