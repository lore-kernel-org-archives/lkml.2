Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2JITSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:18:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46678 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab2JITSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:18:02 -0400
Message-ID: <5074777B.9070907@us.ibm.com>
Date: Tue, 09 Oct 2012 12:14:03 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] time: cast ->raw_interval to u64 to avoid shift overflow
References: <20121009071823.GA19159@elgon.mountain>
In-Reply-To: <20121009071823.GA19159@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12100919-5112-0000-0000-00000D415E1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 12:18 AM, Dan Carpenter wrote:
> We fixed a bunch of integer overflows in timekeeping code during the 3.6
> cycle.  I did an audit based on that and found this potential overflow.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Yep. Looks like this would trigger if you had NOZ idle for more then 4 
seconds.

Thanks for the audit, and sending this in!

Thomas: Mind queuing this?  Probably should be marked for stable too.

Acked-by: John Stultz <johnstul@us.ibm.com>


