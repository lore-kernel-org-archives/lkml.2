Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2ELLkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:40:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14594 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab2ELLkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:40:16 -0400
Message-ID: <4FAE4C13.3040708@parallels.com>
Date: Sat, 12 May 2012 15:40:03 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] proc: Show ns-based inode numbers for /proc/pid/ns/*
 files
References: <4FAD0524.3000307@parallels.com> <877gwi7ije.fsf@xmission.com>
In-Reply-To: <877gwi7ije.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 09:07 PM, Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@parallels.com> writes:
> 
>> Some time ago we tried to expose kernel object IDs to the user space to
>> let it possible to detect shared mm, fs, etc. The namespaces' IDs were
>> included in this set and Eric proposed, that we'd better expose the ID
>> in the stat's st_ino field.
> 
> A quick question.  With kcmp you have something that is at least in
> principle usable for checkpoint restart.

Not only in principle. We do use it already ;)

> Are wanting this for checkpoint restart or something else?

For me -- checkpoint restart only. I'm perfectly fine with checking 
namespaces sharing with kcmp syscall, but you proposed to show ns ID
in proc inode.

> Eric
> .
> 

