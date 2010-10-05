Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0JEFVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:21:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42008 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0JEFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:21:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 14:15:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        steiner@sgi.com
Subject: Re: [PATCH 6/9] v3 Update node sysfs code
Message-Id: <20101005141545.e3a78769.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA629BA.60100@austin.ibm.com>
References: <4CA62700.7010809@austin.ibm.com>
	<4CA629BA.60100@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 13:34:34 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the node sysfs code to be aware of the new capability for a memory
> block to contain multiple memory sections and be aware of the memory block
> structure name changes (start_section_nr).  This requires an additional
> parameter to unregister_mem_sect_under_nodes so that we know which memory
> section of the memory block to unregister.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

