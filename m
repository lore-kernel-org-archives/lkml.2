Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2KBIPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:15:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2KBIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:15:01 -0400
Date: Fri, 2 Nov 2012 11:14:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar amit mehta <gmate.amit@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, syahn@gctsemi.com,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: gdm72xx: wm_ioctl.h: fixed a macro coding style
Message-ID: <20121102081452.GD32762@mwanda>
References: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
 <20121102065555.GC32762@mwanda>
 <20121102073630.GA30619@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102073630.GA30619@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 12:36:30AM -0700, Kumar amit mehta wrote:
> On Fri, Nov 02, 2012 at 09:55:55AM +0300, Dan Carpenter wrote:
> > On Thu, Nov 01, 2012 at 11:42:59PM -0700, Kumar Amit Mehta wrote:
> > > fix for macro coding style.
> > > 
> > 
> > No.  The parenthesis are not needed.  I assume this is a
> > checkpatch.pl warning?
> > 
> > regards,
> > dan carpenter
> >
> Running checkpatch.pl on this file (wm_ioctl.h) returns error.
> 

I think there are patches which fix checkpatch.pl for this but they
haven't been merged yet?

$ ./scripts/checkpatch.pl -f drivers/staging/gdm72xx/wm_ioctl.h
ERROR: Macros with complex values should be enclosed in parenthesis
#94: FILE: staging/gdm72xx/wm_ioctl.h:94:
+#define ifr_name       ifr_ifrn.ifrn_name

total: 1 errors, 0 warnings, 97 lines checked

regards,
dan carpenter

