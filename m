Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1LNVPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:15:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:15483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1LNVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:15:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87374079"
Message-ID: <4EE911F3.4020502@linux.intel.com>
Date: Wed, 14 Dec 2011 13:15:31 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: md: Fix userspace free_pages() macro
References: <1323869678.23971.19.camel@gandalf.stny.rr.com>
In-Reply-To: <1323869678.23971.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 05:34 AM, Steven Rostedt wrote:
> While using etags to find free_pages(), I stumbled across this debug
> definition of free_pages() that is to be used while debugging some raid
> code in userspace. The __get_free_pages() allocates the correct size,
> but the free_pages() does not match. free_pages(), like
> __get_free_pages(), takes an order and not a size.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
