Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0GTInE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:43:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:48275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275Ab0GTInA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:43:00 -0400
Message-ID: <4C45618C.2040905@kernel.org>
Date: Tue, 20 Jul 2010 10:42:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (workqueues
 tree related)
References: <20100720151030.f874832e.sfr@canb.auug.org.au>
In-Reply-To: <20100720151030.f874832e.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 08:42:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 07:10 AM, Stephen Rothwell wrote:
> Hi Tejun,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> kernel/workqueue.c: In function 'alloc_cwqs':
> kernel/workqueue.c:2634: error: 'CONFIG_SMP' undeclared (first use in this function)
> kernel/workqueue.c: In function 'free_cwqs':
> kernel/workqueue.c:2659: error: 'CONFIG_SMP' undeclared (first use in this function)
> 
> Caused by commit f34217977d717385a3e9fd7018ac39fade3964c0 ("workqueue:
> implement unbound workqueue").  Config symbols need to be checked for
> being defined ...

Heh, yeah, I have no idea what I was thinking.  Will fix up soon.

Thanks.

-- 
tejun
