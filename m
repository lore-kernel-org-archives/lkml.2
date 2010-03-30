Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0C3Wjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:39:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0C3Wjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:39:45 -0400
Date: Tue, 30 Mar 2010 14:47:12 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100330214712.GB1388@suse.de>
References: <20100330203842.GA5850@suse.de> <54146.53246.qm@web94908.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54146.53246.qm@web94908.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:35:55AM +0530, Pavan Savoy wrote:
> So, something like the below is ok, I have defined my own pr_fmt,
> however default log level on my board is 7, and hence pr_info is a bit
> more annoying than usual.

No, a driver should use dev_dbg() and other dev_printk() calls, not
pr_debug() or anything like that.

Please don't roll your own formats, use the ones that are well defined
and uniquely describe your driver and device in a format that the whole
kernel uses.

thanks,

greg k-h
