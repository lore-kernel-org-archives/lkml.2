Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2H2NSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:18:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38068 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2H2NSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:18:00 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Joel Becker'" <jlbec@evilplan.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
 <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
 <502CF9E3.2010608@linutronix.de>
 <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
 <502E0D3B.10006@linutronix.de> <000201cd7c63$60186370$20492a50$%p@samsung.com>
 <502E1E23.60201@linutronix.de>
 <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
In-reply-to: <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
Subject: RE: [RFC 0/2] USB gadget - configfs
Date: Wed, 29 Aug 2012 15:17:53 +0200
Message-id: <000001cd85e8$b2c2f340$1848d9c0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1+mQ5hyTVBQJBhTIyVmYuWUfy2wQHTsXcA
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joel,

On Monday, August 20, 2012 8:00 AM Joel Becker wrote:

<snip>

> 	I think what you want here is a symlink.  Create a directory high in
> the tree called 'ready' or 'available', and when you want to lock the
> device in place, symlink it into that directory.  This will pin the item.
> You can also make use of the ->allow_link() and ->drop_link() callbacks to
> prevent symlinking an item until it is fully configured, and prevent
> unlinking an item that is in use.
> 

I have a question to you. In fs/configfs/dir.c, in a comment before
configfs_depend_item and configfs_depend_prep you say that "configfs uses
VFS to handle all locking". I am trying to understand how this
works. Could you please elaborate a bit about it? Which locks from VFS
handle "all locking"? When does locking happen?

Thanks,

Andrzej
 


