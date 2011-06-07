Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1FGMuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:50:10 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:52334 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1FGMuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:50:08 -0400
Message-ID: <4DEE1E76.2060101@free.fr>
Date: Tue, 07 Jun 2011 14:49:58 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: Re: [Patch] doc: remove ns_cgroup from feature-removal-schedule.txt
References: <20110607120630.GA3550@cr0> <4DEE1753.2060307@free.fr> <20110607122233.GB3550@cr0>
In-Reply-To: <20110607122233.GB3550@cr0>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 02:22 PM, Américo Wang wrote:
> On Tue, Jun 07, 2011 at 02:19:31PM +0200, Daniel Lezcano wrote:
>> On 06/07/2011 02:06 PM, Américo Wang wrote:
>>> In the following commit Daniel removed ns_cgroup
>>>
>>> 	commit a77aea92010acf54ad785047234418d5d68772e2
>>> 	Author: Daniel Lezcano<daniel.lezcano@free.fr>
>>> 	Date:   Thu May 26 16:25:23 2011 -0700
>>>
>>> 	    cgroup: remove the ns_cgroup
>>>
>>> but Daniel forgot to remove the related doc in feature-removal-schedule.txt.
>>> This patch removes that too.
>> Well, I am not sure we should remove this entry from the documentation.
> That is a list of features which will be removed,
> not for features that was in the kernel.
>
>> I let this in the doc because people may want to follow what was
>> removed and from what kernel version.
> We have changelogs or git logs, right? :)

Never mind.

The introduction in the doc file is clear:

"... When the feature is removed from the kernel, it should also
be removed from this file."

Sorry I missed this when removing the ns_cgroup.

Thanks for fixing it.

   -- Daniel
