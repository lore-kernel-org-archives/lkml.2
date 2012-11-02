Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2KBHgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:36:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63551 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2KBHgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:36:44 -0400
Date: Fri, 2 Nov 2012 00:36:30 -0700
From: Kumar amit mehta <gmate.amit@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, syahn@gctsemi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: wm_ioctl.h: fixed a macro coding style
Message-ID: <20121102073630.GA30619@gmail.com>
References: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
 <20121102065555.GC32762@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102065555.GC32762@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 09:55:55AM +0300, Dan Carpenter wrote:
> On Thu, Nov 01, 2012 at 11:42:59PM -0700, Kumar Amit Mehta wrote:
> > fix for macro coding style.
> > 
> 
> No.  The parenthesis are not needed.  I assume this is a
> checkpatch.pl warning?
> 
> regards,
> dan carpenter
>
Running checkpatch.pl on this file (wm_ioctl.h) returns error.

Thanks,
Amit
