Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0HEFG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:06:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40101 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEFGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:06:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 14:01:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] v4  Update the node sysfs code
Message-Id: <20100805140129.c52ee636.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581CCB.7070806@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581CCB.7070806@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:42:35 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the node sysfs code to be aware of the new capability for a memory
> block to contain multiple memory sections.  This requires an additional
> parameter to unregister_mem_sect_under_nodes so that we know which memory
> section of the memory block to unregister.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


