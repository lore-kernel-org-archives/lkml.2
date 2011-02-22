Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1BVUc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:32:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:8129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1BVUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=s/8b9pn2ORqIB1XTzYe2Q3SmYoVcvmzv3XB3X7pKUi7VUDEcE6ElUH2TQIpdOxIqKQ
         g1SII2keEuz5gx5KHxSg==
Date: Tue, 22 Feb 2011 12:32:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
In-Reply-To: <4D6419C0.8080804@redhat.com>
Message-ID: <alpine.DEB.2.00.1102221232370.5929@chino.kir.corp.google.com>
References: <4D6419C0.8080804@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Petr Holasek wrote:

> When user insert negative value into /proc/sys/vm/nr_hugepages it will result
> in the setting a random number of HugePages in system (can be easily showed
> at /proc/meminfo output). This patch fixes the wrong behavior so that the
> negative input will result in nr_hugepages value unchanged.
> 
> v2: same fix was also done in hugetlb_overcommit_handler function
>     as suggested by reviewers.
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: David Rientjes <rientjes@google.com>
