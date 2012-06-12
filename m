Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2FLD6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2FLD6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:58:15 -0400
Message-ID: <4FD6BD72.2070808@redhat.com>
Date: Tue, 12 Jun 2012 11:54:26 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com> <1339421268.30462.15.camel@twins>
In-Reply-To: <1339421268.30462.15.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 09:27 PM, Peter Zijlstra wrote:
> On Fri, 2012-06-08 at 21:38 -0400, Zhouping Liu wrote:
>> # cat /sys/devices/system/node/node*/distance
>> 10 17 17 24 24 24 30 30
>> 18 10 30 18 18 24 24 24
>> 18 24 10 24 24 17 30 30
>> 24 18 23 10 24 17 17 30
>> 24 17 24 24 10 18 30 18
>> 31 24 17 18 18 10 24 24
>> 30 24 30 17 24 24 10 18
>> 30 24 30 24 17 24 17 10
> You have to be kidding me right? That thing is a complete trainwreck,
> what idiot vendor did this?

it's a HP's machine.
If I understand correctly, you meant the hardware has a bad configuration,
just serious :) could you explain  the reason? (you can ignore it if 
it's a stupid question)

>
> If you boot that machine again, does it have the same stupid table or
> are we staring at white-noise?

indeed, it's always the same table.

And the issues is gone in the latest Linus tree(commit b84297197ce60),
I'm not sure which patches fixed the issue.

Thanks,
Zhouping
