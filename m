Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab0EEQUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:20:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22118 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab0EEQUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:20:48 -0400
Date: Wed, 5 May 2010 09:20:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Joern Engel <joern@logfs.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       logfs@logfs.org
Subject: Re: linux-next: Tree for April 28 (logfs)
Message-Id: <20100505092020.66a461fa.randy.dunlap@oracle.com>
In-Reply-To: <20100428085604.0566092a.randy.dunlap@oracle.com>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au>
	<20100428085604.0566092a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BE19AD4.01EF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 08:56:04 -0700 Randy Dunlap wrote:

> 
> When CONFIG_BLOCK is not enabled:
> 
> fs/logfs/super.c:142: error: implicit declaration of function 'bdev_get_queue'
> fs/logfs/super.c:142: error: invalid type argument of '->' (have 'int')


Still have this build error in linux-next-May 5-2010.

[and L:      logfs@logfs.org
is moderated for non-subscribers]

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
