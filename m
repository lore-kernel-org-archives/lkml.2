Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2EUUej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:34:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46896 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab2EUUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:34:37 -0400
Message-ID: <4FBAA6D7.2000604@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 13:34:31 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 1/2] hugetlb: fix resv_map leak in error path
References: <20120521203022.F7FCE507@kernel>
In-Reply-To: <20120521203022.F7FCE507@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052120-3270-0000-0000-000006853DC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 01:30 PM, Dave Hansen wrote:
> When called for anonymous (non-shared) mappings,
> hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
> code in hugetlbfs's vm_ops->close() to release that allocation.

Sorry, this one escaped unintentionally!  This patch itself is good, but
I didn't mean to send it along with 2/2.  Disregard this 1/2, but please
take a look at 2/2!

