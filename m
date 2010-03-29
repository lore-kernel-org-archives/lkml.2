Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0C2SI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:08:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab0C2SI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:08:27 -0400
Message-ID: <4BB0ED4F.2080102@kernel.org>
Date: Tue, 30 Mar 2010 03:11:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH -next] kmemcheck: build failure after merge of the slabh
 tree
References: <20100329154208.009a8ae2.sfr@canb.auug.org.au> <20100329092513.6e6faf2a.randy.dunlap@oracle.com> <4BB0EAD0.2030807@kernel.org>
In-Reply-To: <4BB0EAD0.2030807@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 18:08:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 03:00 AM, Tejun Heo wrote:
>> mm/kmemcheck.c also needs slab.h added to it:
> 
> But this one is something I missed from the mainline (my script didn't
> check for isolated SLAB_* flag usages).  I'll take this one into the
> slabh tree.  Thanks for reporting this.  :-)

Applied to slabh branch.  Thanks.

-- 
tejun
