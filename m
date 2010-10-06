Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0JGAEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:04:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47766 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0JGAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:04:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Oct 2010 08:58:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: containers@lists.linux-foundation.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Restrict size of page_cgroup->flags
Message-Id: <20101007085858.0e07de59.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101006142314.GG4195@balbir.in.ibm.com>
References: <20101006142314.GG4195@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010 19:53:14 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I propose restricting page_cgroup.flags to 16 bits. The patch for the
> same is below. Comments?
> 
> 
> Restrict the bits usage in page_cgroup.flags
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Restricting the flags helps control growth of the flags unbound.
> Restriciting it to 16 bits gives us the possibility of merging
> cgroup id with flags (atomicity permitting) and saving a whole
> long word in page_cgroup
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Doesn't make sense until you show the usage of existing bits.
And I guess 16bit may be too large on 32bit systems.

Nack for now.

Thanks,
-Kame

