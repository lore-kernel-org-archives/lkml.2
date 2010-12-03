Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0LCRur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:50:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56214 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab0LCRup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:50:45 -0500
Date: Fri, 3 Dec 2010 09:48:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <sfrench@samba.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: Tree for December 3 (cifs)
Message-Id: <20101203094844.68f2bc40.randy.dunlap@oracle.com>
In-Reply-To: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101202:


When CIFS_EXPERIMENTAL is not enabled:

(.text+0xdf6c9): undefined reference to `get_cifs_acl'

from fs/cifs/xattr.c:cifs_getxattr()


CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_EXPERIMENTAL is not set


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
