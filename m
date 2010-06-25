Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0FYO4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:56:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab0FYO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:56:30 -0400
Date: Fri, 25 Jun 2010 16:56:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100625145622.GB13421@basil.fritz.box>
References: <4C24012B.9030506@austin.ibm.com>
 <20100625105340.803C.A69D9226@jp.fujitsu.com>
 <87d3vfeage.fsf@basil.nowhere.org>
 <4C24C279.3050206@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C24C279.3050206@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 09:51:37AM -0500, Nathan Fontenot wrote:
> > 
> >>> Proposed patch to disable memory hotplug via a boot option,
> >>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
> >>> prevents the creation of the memory sysfs directories for memory sections.
> >>>
> >>> This patch is meant to help alleviate very long boot times on systems with
> >>> large memory (1+ TB) and many memory sections (10's of thousands).
> >>
> >> Why making simple /sys file is so slowly? Couldn't we fix such performance
> >> problem?
> 
> The issue is the large number of sysfs memory directories that get created.
> On a system with 1 TB of memory I am seeing ~63,00 directories.  The long

Maybe you could simply make the memory blocks larger on such large systems?
I agree 6k blocks are probably not very useful, but maybe 10 or 100 are?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
