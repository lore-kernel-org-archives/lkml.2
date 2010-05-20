Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0ETTxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:53:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49345 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab0ETTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:52:57 -0400
Date: Thu, 20 May 2010 12:52:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ceph-devel@vger.kernel.org
Subject: Re: linux-next: Tree for May 20 (ceph)
Message-Id: <20100520125232.0341d995.randy.dunlap@oracle.com>
In-Reply-To: <20100520163042.9486e077.sfr@canb.auug.org.au>
References: <20100520163042.9486e077.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BF59315.0016:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 16:30:42 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> We are in the merge window again.  I remind you all not to add stuff for
> 2.6.36 to your linux-next trees until after 2.6.35-rc1.


when CONFIG_BLOCK is not enabled:

fs/ceph/messenger.c:732: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:740: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:740: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:740: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:743: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:744: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:793: error: implicit declaration of function 'bio_iovec_idx'
fs/ceph/messenger.c:793: warning : assignment makes pointer from integer without a cast
fs/ceph/messenger.c:794: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:795: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:798: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1406: warning: initialization makes pointer from integer without a cast
fs/ceph/messenger.c:1413: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1413: warning: type defaults to 'int' in declaration of '_min2'
fs/ceph/messenger.c:1413: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1416: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1416: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1424: error: dereferencing pointer to incomplete type
fs/ceph/messenger.c:1429: error: dereferencing pointer to incomplete type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
