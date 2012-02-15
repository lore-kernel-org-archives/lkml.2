Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab2BOJgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:36:12 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43860 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab2BOJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:36:07 -0500
Message-ID: <4F3B7C80.2080802@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 15:06:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] cpumask: remove old cpu_*_map.
References: <1329281884.18410.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.18410.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021423-9264-0000-0000-000000D5F09E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 10:28 AM, Rusty Russell wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> These are obsolete: cpu_*_mask provides (const) pointers.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---


This one should be preceded by a cleanup patch in ia64.
I will revise the one I posted at https://lkml.org/lkml/2012/2/14/355
and post it soon. And then you can include my patch in your patchset...

Other than that, this looks fine.
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

