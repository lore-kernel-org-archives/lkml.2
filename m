Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0JTOb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:31:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:35006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0JTObz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:31:55 -0400
Date: Wed, 20 Oct 2010 07:14:26 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: batman-adv: remove useless addr_to_string()
Message-ID: <20101020141426.GA14590@suse.de>
References: <20101019170342.GA18575@kroah.com> <1287574044-23000-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287574044-23000-1-git-send-email-andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:27:24PM +0300, Andy Shevchenko wrote:
> Since all *printf() methods in the kernel understand '%pM' modifier the
> conversion to the string is useless beforehand.
> 
> Additionally this patch decreases batman_if structure by 20 bytes.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Please also read the TODO file in this directory, which says who to copy
on patches for these files.  Care to resend it with those addresses
added?

thanks,

greg k-h
