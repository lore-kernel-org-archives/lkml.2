Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0IPTwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:52:04 -0400
Received: from kroah.org ([198.145.64.141]:39098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab0IPTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:52:02 -0400
Date: Thu, 16 Sep 2010 12:32:01 -0700
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Al Cho <acho@novell.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: keucr: check kmalloc() return value
Message-ID: <20100916193201.GC10397@kroah.com>
References: <1284317808-4850-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284317808-4850-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 10:56:43PM +0400, Vasiliy Kulikov wrote:
> kmalloc() may fail, if so return error code.
> Also don't alloc 16 bytes from the heap, use stack instead.

Nope, you can't do that for USB drivers, sorry.  Please read the
documentation, it states this very clearly.

thanks,

greg k-h
