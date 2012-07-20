Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2GTIYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:24:38 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34656 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2GTIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:24:35 -0400
Message-ID: <500915B9.2030104@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 16:24:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mgalbraith@novell.com, mmokrejs@fold.natur.cuni.cz
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <20120720064156.GI16348@mwanda>
In-Reply-To: <20120720064156.GI16348@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072008-8256-0000-0000-0000036264CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 02:41 PM, Dan Carpenter wrote:
> My bug was fixed in March.  There was an email thread about it when
> the merge window opened but I can't find it...
Hi, Dan

Thanks for your reply.

Currently this issue won't appear because the
CONFIG_RCU_CPU_STALL_TIMEOUT=60, which is big enough to avoid the
warning info.

So is this the fix you mentioned? or someone has find out the true
reason and fixed it?

Regards,
Michael Wang
> 
> regards,
> dan carpenter
> 


