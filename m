Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2LKXUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:20:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:20:36 -0500
Date: Tue, 11 Dec 2012 15:20:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 2/2] uio: do not expose inode to uio open/release hooks
Message-ID: <20121211232032.GA24933@kroah.com>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 12:12:02AM +0100, Benedikt Spranger wrote:
> The inode parameter is unused by in kernel users of UIO.

Ok.

> Also the inode parameter makes it hard to resolve the existing open(),
> mmap() and close() difficulty.

I don't understand, what do you mean by this?  What is this parameter
causing problems with?

greg k-h
