Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0JEFSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:18:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41864 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0JEFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:18:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 14:13:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        steiner@sgi.com
Subject: Re: [PATCH 4/9] v3 Allow memory blocks to span multiple memory
 sections
Message-Id: <20101005141325.81c61dec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA62FE2.2000003@austin.ibm.com>
References: <4CA62700.7010809@austin.ibm.com>
	<4CA62917.80008@austin.ibm.com>
	<4CA62FE2.2000003@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 14:00:50 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the memory sysfs code such that each sysfs memory directory is now
> considered a memory block that can span multiple memory sections per
> memory block.  The default size of each memory block is SECTION_SIZE_BITS
> to maintain the current behavior of having a single memory section per
> memory block (i.e. one sysfs directory per memory section).
> 
> For architectures that want to have memory blocks span multiple
> memory sections they need only define their own memory_block_size_bytes()
> routine.
> 
This should be commented in code before MEMORY_BLOCK_SIZE declaration.

> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>




