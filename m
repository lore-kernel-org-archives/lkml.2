Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893Ab2JZSN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:13:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:34302 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965748Ab2JZSNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:13:24 -0400
Date: Fri, 26 Oct 2012 11:13:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yan Hong <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] debugfs: pass NULL as the last parameter of
 debugfs_print_regs32()
Message-ID: <20121026181323.GD25530@kroah.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 01:55:42AM +0800, Yan Hong wrote:
> Pass NULL instead of empty string to debugfs_print_regs32() when
> prefix is not used, according to the intention of the code.

Is this solving a problem?  Is it wrong as-is?  Is it causing an issue
today?

thanks,

greg k-h
