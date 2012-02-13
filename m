Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2BMQtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:49:10 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27585 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab2BMQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:49:07 -0500
Message-ID: <4F393EE7.4050805@parallels.com>
Date: Mon, 13 Feb 2012 20:48:39 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: Re: [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6> <4F356206.1080509@schaufler-ca.com> <4F38EE17.7090809@parallels.com> <20120213161135.GE5009@sergelap>
In-Reply-To: <20120213161135.GE5009@sergelap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.02.2012 20:11, Serge Hallyn пишет:
> Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
>> 10.02.2012 22:29, Casey Schaufler пишет:
>>> On 2/9/2012 10:01 AM, Stanislav Kinsbursky wrote:
>>>> This patch set aimed to provide additional functionality for all IPC objects,
>>>> which is required for migration these objects by user-space checkpoint/restore
>>>> utils.
>>>> The main problem here was impossibility to set up object id. This patch set
>>>> solves the problem in two steps:
>>>> 1) Makes it possible to create new object (shared memory, semaphores set or
>>>> messages queue) with ID, equal to passed key.
>>>> 2) Makes it possible to change existent object key.
>>>
>>> Is there any chance you might include the LSM data as well?
>>>
>>
>> Sorry, but I don't understand your question.
>> What is this "LSM"? Linux Shared Memory? If yes, and you mean SYSV
>> IPC SHM, then where do you want to include it?
>
> He means linux security modules.  (see include/linux/security.h)

Ok, thanks for explanation.
Casey, what exactly you are asking about? Am I going to implement 
security_*_set() functions?

-- 
Best regards,
Stanislav Kinsbursky
