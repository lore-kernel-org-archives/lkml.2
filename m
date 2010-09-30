Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0I3CGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:06:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41229 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0I3CGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:06:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Sep 2010 11:01:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>,
        Badari Pulavarty <pbadari@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Hansen <haveblue@us.ibm.com>,
        Matt Tolentino <matthew.e.tolentino@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [Patch 3/3] Convert link_mem_sections to use
 find_memory_block_hinted.
Message-Id: <20100930110128.cd1a8606.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100929190115.766603780@gulag1.americas.sgi.com>
References: <20100929190053.992911934@gulag1.americas.sgi.com>
	<20100929190115.766603780@gulag1.americas.sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 14:00:56 -0500
Robin Holt <holt@sgi.com> wrote:

> 
> Modify link_mem_sections() to pass in the previous mem_block as a hint to
> locating the next mem_block.  Since they are typically added in order this
> results in a massive saving in time during boot of a very large system.
> For example, on a 16TB x86_64 machine, it reduced the total time spent
> linking all node's memory sections from 1 hour, 27 minutes to 46 seconds.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Gary Hade <garyhade@us.ibm.com>
> To: Badari Pulavarty <pbadari@us.ibm.com>
> To: Ingo Molnar <mingo@elte.hu>
> Cc: lkml <linux-kernel@vger.kernel.org>
> 
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

