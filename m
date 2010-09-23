Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0IWSPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:15:52 -0400
Received: from xenotime.net ([72.52.115.56]:44333 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753341Ab0IWSPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:15:52 -0400
Date: Thu, 23 Sep 2010 11:15:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kay Sievers <kay.sievers@vrfy.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] driver core: fix build for CONFIG_BLOCK=n
Message-Id: <20100923111541.97abcd05.rdunlap@xenotime.net>
In-Reply-To: <20100921223115.GB21202@kroah.com>
References: <20100920161239.f204a507.sfr@canb.auug.org.au>
	<20100920092034.0b3f5898.randy.dunlap@oracle.com>
	<20100921223115.GB21202@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 15:31:15 -0700 Greg KH wrote:

> On Mon, Sep 20, 2010 at 09:20:34AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix build when CONFIG_BLOCK is not enabled (since SEP-06).
> > Fixes these build errors:
> > 
> > drivers/base/core.c: In function 'get_device_parent':
> > drivers/base/core.c:622: error: 'block_class' undeclared (first use in this function)
> > drivers/base/core.c: In function 'device_add_class_symlinks':
> > drivers/base/core.c:712: error: 'block_class' undeclared (first use in this function)
> > drivers/base/core.c: In function 'device_remove_class_symlinks':
> > drivers/base/core.c:742: error: 'block_class' undeclared (first use in this function)
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> This should no longer be needed with the next linux-next tree as the
> logic in this area has changed thanks to Andi's patch.

{sorry about resend, email problems}


Still seeing this build error. (linux-next 2010-0923)
Will you be merging some patch soon?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
