Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1KNTpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:45:07 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49571 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1KNTpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:45:06 -0500
Message-ID: <4EC16F97.2020008@parallels.com>
Date: Mon, 14 Nov 2011 17:44:23 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <fweisbec@gmail.com>
Subject: Re: [PATCH v2 01/14] trivial: initialize root cgroup's sibling list
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-2-git-send-email-glommer@parallels.com> <4EBD94CE.4050206@google.com>
In-Reply-To: <4EBD94CE.4050206@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 07:34 PM, Paul Turner wrote:
> On 11/01/2011 02:19 PM, Glauber Costa wrote:
>> Even though there are no siblings, the list should be
>> initialized not to contain bogus values.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> Acked-by: Paul Menage<paul@paulmenage.org>
>
> Signed-off-by: Paul Turner <pjt@google.com>
>
Since this is pretty trivial, I would like to keep it out of my next 
submission. Would any of you pick this one individually to your trees?

Thanks

