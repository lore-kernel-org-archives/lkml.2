Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2HTOqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:46:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39611 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HTOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:46:18 -0400
Date: Mon, 20 Aug 2012 07:46:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 00/46] 3.5.3-stable review
Message-ID: <20120820144613.GA27130@kroah.com>
References: <20120820035832.274275502@linuxfoundation.org>
 <pan.2012.08.20.08.26.25.90194@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2012.08.20.08.26.25.90194@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:26:25AM +0200, Holger Hoffstaette wrote:
> (CC: J. Bruce Fields)
> 
> Greg,
> 
> it looks like a fix for a regression in NFS is not mentioned in this
> patch even though it was supposedly sent to -stable:
> http://lkml.indiana.edu/hypermail/linux/kernel/1208.2/00594.html
> 
> I tried to locate the patch in git but could not find it anywhere. As far
> as I can tell the fix works; in my case I noticed repeatable hangs when
> trying to "move files to the trash" in XFCE and these hangs are now gone.
> Have not noticed any negative side effects either.

Is the patch you reference above in Linus's tree?  That is a requirement
before I can accept it into a stable release (please read
Documentation/stable_kernel_rules.txt for the details.)

greg k-h
