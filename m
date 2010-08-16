Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0HPRIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:08:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24290 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0HPRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:08:20 -0400
Date: Mon, 16 Aug 2010 10:08:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org
Subject: Re: linux-next: Tree for August 16 (ceph)
Message-Id: <20100816100808.ff0fa2b4.randy.dunlap@oracle.com>
In-Reply-To: <20100816150420.7f3f8cfd.sfr@canb.auug.org.au>
References: <20100816150420.7f3f8cfd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 15:04:20 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> As the merge window has closed, let the flood commence. :-)
> 
> Changes since 20100813:


linux-next-20100816/net/ceph/debugfs.c:255: error: conflicting types for 'ceph_debugfs_client_init'
linux-next-20100816/include/linux/ceph/debugfs.h:29: note: previous declaration of 'ceph_debugfs_client_init' was here



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
