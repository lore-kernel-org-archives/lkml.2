Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0CQXBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:01:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:51185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CQXBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:01:37 -0400
Message-ID: <4BA15F29.6030409@kernel.org>
Date: Thu, 18 Mar 2010 08:00:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org>  <alpine.DEB.2.00.1003161107070.2311@router.home>  <4BA00CE4.1090108@kernel.org>  <alpine.DEB.2.00.1003171134070.27268@router.home> <1268846083.4773.64.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.1003171453530.4231@router.home>
In-Reply-To: <alpine.DEB.2.00.1003171453530.4231@router.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 23:00:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 04:54 AM, Christoph Lameter wrote:
> On Wed, 17 Mar 2010, Lee Schermerhorn wrote:
> 
>> s/from slab.h/from topology.h/ is the update Christoph is indicating.
>> Right, Christoph?
> 
> Right.

OIC, I'll update accordingly.  Thanks.

-- 
tejun
