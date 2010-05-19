Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0ESPvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:51:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:64578 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0ESPvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:51:51 -0400
Message-ID: <4BF408CF.5020209@windriver.com>
Date: Wed, 19 May 2010 10:50:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/17] kdb: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org><1269885165-18617-3-git-send-email-tj@kernel.org> <20100520013340.1fcc2c0d.sfr@canb.auug.org.au>
In-Reply-To: <20100520013340.1fcc2c0d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2010 15:50:40.0910 (UTC) FILETIME=[0877A2E0:01CAF76B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 10:33 AM, Stephen Rothwell wrote:
> Hi Jason,
>
> On Tue, 30 Mar 2010 02:52:30 +0900 Tejun Heo <tj@kernel.org> wrote:
>   
>> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>> gfp.h or slab.h is included as necessary.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Cc: Jason Wessel <jason.wessel@windriver.com>
>>     
>
> Please apply to the kgdb tree (patch reposted below).
>
>   

No problem.

Looks like it got missed earlier, because I have a fixup from you for
the kdb_support.c file.

I folded this into kgdb-next.

Cheers,
Jason.
