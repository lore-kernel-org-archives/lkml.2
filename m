Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2I1Juv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:50:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46478 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2I1Juu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:50:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5934216"
Message-ID: <5065737B.1050709@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 17:52:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] workqueue: remove WORKER_STARTED
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-8-git-send-email-laijs@cn.fujitsu.com> <20120926183616.GH12544@google.com>
In-Reply-To: <20120926183616.GH12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 17:50:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 17:50:58,
	Serialize complete at 2012/09/28 17:50:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:36 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 01:20:38AM +0800, Lai Jiangshan wrote:
>> All newly created worker will enter idle soon,
>> WORKER_STARTED is not used any more, remove it.
> 
> Please merge this with the previous patch.
> 

OK, I will do it.

Thanks,
Lai
