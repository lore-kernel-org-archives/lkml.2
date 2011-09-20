Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1ITMXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:23:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46716 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1ITMXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:23:30 -0400
Message-ID: <4E788590.4040301@parallels.com>
Date: Tue, 20 Sep 2011 09:22:40 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 7/9] Create cpuacct.proc.stat file
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316030695-19826-8-git-send-email-glommer@parallels.com> <1316510564.11841.16.camel@twins>
In-Reply-To: <1316510564.11841.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 06:22 AM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>> When doing containers, this file represents how /proc/stat should like
>> from inside it. It is user, system, etc, from the perspective of
>> the current cgroup.
>>
> It would be very nice indeed if you could unify fs/proc/stat.c and this.

I think it is a good idea.
