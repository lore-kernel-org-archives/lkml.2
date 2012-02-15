Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab2BOJXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:23:55 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57188 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660Ab2BOJXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:23:53 -0500
Message-ID: <4F3B79A2.3070709@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 14:53:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, davej@redhat.com,
        jonas.aberg@stericsson.com, martin.persson@stericsson.com,
        sundar.iyer@stericsson.com, Venkatesh Pallipadi <venki@google.com>,
        "akpm >> \"akpm@linux-foundation.org\"" <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/12] drivers/cpufreq/db8500-cpufreq: remove references
 to cpu_*_map.
References: <1329281884.20530.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.20530.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021423-1396-0000-0000-000000ADABD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 10:28 AM, Rusty Russell wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Dave Jones <davej@redhat.com>
> Cc: cpufreq@vger.kernel.org
> Cc: Sundar Iyer <sundar.iyer@stericsson.com>
> Cc: Martin Persson <martin.persson@stericsson.com>
> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
> ---


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

