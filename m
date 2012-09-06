Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab2IFBox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:44:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42075 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab2IFBow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:44:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,377,1344182400"; 
   d="scan'208";a="5791463"
Message-ID: <5047F2B3.5060807@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 08:47:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: fix possible deadlock in idle worker rebinding
References: <20120905061233.GA3195@dhcp-172-17-108-109.mtv.corp.google.com> <20120905061632.GB3195@dhcp-172-17-108-109.mtv.corp.google.com> <20120905231116.GD29092@google.com>
In-Reply-To: <20120905231116.GD29092@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 08:45:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 08:45:37,
	Serialize complete at 2012/09/06 08:45:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 07:11 AM, Tejun Heo wrote:
> On Tue, Sep 04, 2012 at 11:16:32PM -0700, Tejun Heo wrote:
>> Currently, rebind_workers() and idle_worker_rebind() are two-way
>> interlocked.  rebind_workers() waits for idle workers to finish
>> rebinding and rebound idle workers wait for rebind_workers() to finish
>> rebinding busy workers before proceeding.
> 
> Applied to wq/for-3.6-fixes.
> 
> Thanks.
> 

OK for me.

Thanks.
Lai
