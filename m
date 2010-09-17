Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0IQJ6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:58:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:35607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0IQJ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:58:17 -0400
Message-ID: <4C933B99.9050209@kernel.org>
Date: Fri, 17 Sep 2010 11:57:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM / Runtime: Use alloc_workqueue() for creating
 PM workqueue
References: <201009152156.30749.rjw@sisk.pl> <4C91D132.6090607@kernel.org> <201009162024.51520.rjw@sisk.pl>
In-Reply-To: <201009162024.51520.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 09:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 08:24 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Use alloc_workqueue() for creating the PM workqueue
> 
> Although we need the PM workqueue to be freezable, we don't need it
> to be singlethread.  Also, the number of concurrent work items
> running on a single CPU need not be constrained.  For these reasons
> use alloc_workqueue() directly, with suitable arguments, instead of
> create_freezeable_workqueue(), to create the runtime PM workqueue.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
