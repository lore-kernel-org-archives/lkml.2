Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2GEJOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:14:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab2GEJOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:14:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,530,1336320000"; 
   d="scan'208";a="5334730"
Message-ID: <4FF55B23.40402@cn.fujitsu.com>
Date: Thu, 05 Jul 2012 17:15:15 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com, tj@kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] cgroup: fix panic in netprio_cgroup
References: <1341477102-16988-1-git-send-email-gaofeng@cn.fujitsu.com> <20120705.015841.2231353345763821829.davem@davemloft.net>
In-Reply-To: <20120705.015841.2231353345763821829.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/05 17:14:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/05 17:14:54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月05日 16:58, David Miller 写道:
> 
> Why did you post this twice?

Sorry to confuse you, there are something wrong with my git sendmail config.
I sent the first patch but I can't find it in the maillist,so I
sent it again.


> 
> Is there a difference between the first patch and the second
> one you posted?  If so, what is that difference?

there isn't a difference between them.
Sorry again.

Thanks.
