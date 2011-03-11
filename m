Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1CKRyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:54:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CKRyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:54:20 -0500
Date: Fri, 11 Mar 2011 09:53:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 11 (block/mm/fs)
Message-Id: <20110311095325.10ec7383.randy.dunlap@oracle.com>
In-Reply-To: <20110311184115.33404b77.sfr@canb.auug.org.au>
References: <20110311184115.33404b77.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D7A61BB.0009,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 18:41:15 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110310:
> 
> The block tree lost its build failure but gained another for which I
> applied a patch.


When CONFIG_BLOCK is not enabled:

mm/filemap.c:1257: error: storage size of 'plug' isn't known
mm/filemap.c:2450: error: storage size of 'plug' isn't known
mm/readahead.c:112: error: storage size of 'plug' isn't known
fs/aio.c:1625: error: storage size of 'plug' isn't known


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
