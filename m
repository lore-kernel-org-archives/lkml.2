Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2DCDYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 23:24:33 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43351 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2DCDYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 23:24:32 -0400
Message-ID: <4F7A6D13.4060704@parallels.com>
Date: Tue, 3 Apr 2012 07:22:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <20120330222936.GI28934@google.com>
In-Reply-To: <20120330222936.GI28934@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.208.8.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 02:29 AM, Tejun Heo wrote:
> On Wed, Mar 21, 2012 at 03:17:33PM -0700, Tejun Heo wrote:
>> and is also available in the following git branch.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup-cftype
>
> Branch has been refreshed on top of the current mainline and with the
> updated patch.
>
> Thanks.
>
Do I need to send you a patch to remove memcg's populate on top of this ?
