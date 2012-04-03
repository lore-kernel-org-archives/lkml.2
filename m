Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2DCUjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:39:09 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44298 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab2DCUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:39:07 -0400
Message-ID: <4F7B5F91.7030405@parallels.com>
Date: Wed, 4 Apr 2012 00:37:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <20120330222936.GI28934@google.com> <4F7A6D13.4060704@parallels.com> <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com> <20120403185216.GD27794@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120403185216.GD27794@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.208.8.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 10:52 PM, Tejun Heo wrote:
> On Tue, Apr 03, 2012 at 11:47:19AM -0700, Tejun Heo wrote:
>> Hello, Glauber.
>>
>> On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
>>> Do I need to send you a patch to remove memcg's populate on top of this ?
>>
>> populate is already gone.  My memory is a bit fuzzy now.  Can you spot
>> something broken / to be improved re. memcg cftypes in the current
>> cgroup/for-3.5 branch?
>
> Ugh... brainfart.  Please disregard the previous message.  Can you
> please resend the patches on top of cgroup/for-3.5 and use Li's new
> address - lizefan@huawei.com ?
>
> Thanks.
>
All right.
I'll give a new test to make sure it is still okay, and send shortly
