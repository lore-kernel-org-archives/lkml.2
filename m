Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab2JaRjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:39:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37338 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270Ab2JaRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:39:21 -0400
Message-ID: <50916238.4040800@parallels.com>
Date: Wed, 31 Oct 2012 21:39:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <lizefan@huawei.com>, <hannes@cmpxchg.org>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-3-git-send-email-tj@kernel.org> <20121031153926.GC22809@dhcp22.suse.cz> <20121031165739.GE2945@htj.dyndns.org> <50915A87.4070504@parallels.com> <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com> <50915DB7.5020706@parallels.com> <20121031172522.GJ2945@htj.dyndns.org>
In-Reply-To: <20121031172522.GJ2945@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 09:25 PM, Tejun Heo wrote:
> More proper names for these callbacks would be,
> 
> 	->allocate()
> 	->online()
> 	->offline()
> 	->free()
I support the name change, btw.


