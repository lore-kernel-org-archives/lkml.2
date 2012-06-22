Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640Ab2FVPhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:37:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab2FVPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:37:01 -0400
Date: Fri, 22 Jun 2012 08:36:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 09/12] commit 22126843cb3c2a782c2d52614486115f3e9db478
Message-ID: <20120622153657.GB6081@kroah.com>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
 <20120622154438.1405.43658.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622154438.1405.43658.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:44:59PM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> tty: move the termios object into the tty
> 
>     This will let us sort out a whole pile of tty related races. The
>     alternative would be to keep points and refcount the termios objects.
>     However
>     1. They are tiny anyway
>     2. Many devices don't use the stored copies
>     3. We can remove a pty special case
> 
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

Odd subject line, and formatting, did something go wrong with your
scripts?
