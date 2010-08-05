Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0HEFA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:00:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47532 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEFAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:00:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 13:55:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/9] v4  Allow memory_block to span multiple memory
 sections
Message-Id: <20100805135531.498625ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581C61.1050408@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581C61.1050408@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:40:49 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the memory sysfs code that each sysfs memory directory is now
> considered a memory block that can contain multiple memory sections per
> memory block.  The default size of each memory block is SECTION_SIZE_BITS
> to maintain the current behavior of having a single memory section per
> memory block (i.e. one sysfs directory per memory section).
> 
> For architectures that want to have memory blocks span multiple
> memory sections they need only define their own memory_block_size_bytes()
> routine.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
(But maybe it's better to get ppc guy's Ack.)


