Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2DXJR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:17:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44603 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2DXJRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:17:53 -0400
Message-ID: <4F966FAA.1030901@openvz.org>
Date: Tue, 24 Apr 2012 13:17:30 +0400
From: Kinsbursky Stanislav <skinsbursky@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: [CRIU] [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6> <4F54B9DE.60604@openvz.org> <20120306151954.bc50817c.akpm@linux-foundation.org>
In-Reply-To: <20120306151954.bc50817c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.2012 03:19, Andrew Morton wrote:
> On Mon, 05 Mar 2012 17:04:30 +0400
> Kinsbursky Stanislav<skinsbursky@openvz.org>  wrote:
>
>> 09.02.2012 22:01, Stanislav Kinsbursky __________:
>>> This patch set aimed to provide additional functionality for all IPC objects,
>>> which is required for migration these objects by user-space checkpoint/restore
>>> utils.
>>> The main problem here was impossibility to set up object id. This patch set
>>> solves the problem in two steps:
>>> 1) Makes it possible to create new object (shared memory, semaphores set or
>>> messages queue) with ID, equal to passed key.
>>> 2) Makes it possible to change existent object key.
>> Hello, Andrew.
>> Are you going to take this patch set?
>>
> (top-posting repaired - please don't do that)
>
> I haven't forgotten about it :(.  There has been little review feedback
> on this patchset and I still have overall concerns about the approach
> we've been taking to c/r development.  I have a lengthy Feb 15 email
> from Pavel which I also haven't forgotten about, but I haven't got back
> to thinking about the whole topic yet, sorry.  Soon...

Hi, Andrew.
Just wondering about this patch set - have you commited it yet?
Or you need something from me to do this?

-- 
Best regards,
Stanislav Kinsbursky

