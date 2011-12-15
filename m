Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1LOHET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:04:19 -0500
Received: from mx2.parallels.com ([64.131.90.16]:54712 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab1LOHEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:04:16 -0500
Message-ID: <4EE99BCA.1010505@parallels.com>
Date: Thu, 15 Dec 2011 11:03:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <cgroups@vger.kernel.org>,
        <bsingharora@gmail.com>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] make clone_children a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com> <4EE80A0D.7090808@cn.fujitsu.com> <4EE84B9A.90901@parallels.com> <20111214181852.GB20380@google.com>
In-Reply-To: <20111214181852.GB20380@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:18 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Dec 14, 2011 at 11:09:14AM +0400, Glauber Costa wrote:
>> That's indeed confusing, and it comes from the fact that we always
>> inherit clone_children from the parent - which is sane, IMHO. So
>> this flag only has any value in establishing the initial behaviour
>> of the top root cgroup. I wonder then if it wouldn't better to just
>> be explicit and fail in this case ?
>
> I don't think all current behaviors are sane and if not let's change
> them, but those things have to be explicit with proper description and
> rationale.
>

140 % agree to that. As I said, I wrongly believed it to be functionally 
equivalent when I sent it, but missed the flags remount check.

If you believe the behavior we now get is saner, I can rewrite the 
Changelog and resend it.

