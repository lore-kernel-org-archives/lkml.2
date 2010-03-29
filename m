Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0C2R5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:57:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab0C2R5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:57:49 -0400
Message-ID: <4BB0EAD0.2030807@kernel.org>
Date: Tue, 30 Mar 2010 03:00:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH -next] kmemcheck: build failure after merge of the slabh
 tree
References: <20100329154208.009a8ae2.sfr@canb.auug.org.au> <20100329092513.6e6faf2a.randy.dunlap@oracle.com>
In-Reply-To: <20100329092513.6e6faf2a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/30/2010 01:25 AM, Randy Dunlap wrote:
> This tree seems to be a bit messy.  :(

Sorry.  Most of the failures came from me forgetting to run the
conversion script on codes which are in linux-next but not mainline,
so all the new codes ended up broken by default.  I just sent out
patches against trees in linux-next.  Once they're in, there shouldn't
be many problems.

> Sorry if I missed this patch in the (email) storm.
> 
> mm/kmemcheck.c also needs slab.h added to it:

But this one is something I missed from the mainline (my script didn't
check for isolated SLAB_* flag usages).  I'll take this one into the
slabh tree.  Thanks for reporting this.  :-)

-- 
tejun
