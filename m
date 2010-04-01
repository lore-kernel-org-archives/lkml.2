Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0DAQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:15:17 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:28871 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab0DAQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:15:12 -0400
Date: Thu, 1 Apr 2010 09:13:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 1 (virtio_blk warning)
Message-Id: <20100401091312.85775242.randy.dunlap@oracle.com>
In-Reply-To: <20100401172317.80b6d961.sfr@canb.auug.org.au>
References: <20100401172317.80b6d961.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB4C682.0122:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 17:23:17 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100331:


drivers/block/virtio_blk.c:228:13: warning: multi-character character constant

due to:

	if (cmd == 'VBID') {

---
~Randy
