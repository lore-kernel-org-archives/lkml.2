Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1JUKqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 06:46:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60685 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1JUKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 06:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1110210232450.31056@tundra.namei.org>
References: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com>
	<alpine.LRH.2.00.1110210232450.31056@tundra.namei.org>
Date: Fri, 21 Oct 2011 18:46:28 +0800
Message-ID: <CAH-7YMmx0J+pQFfrU4KW2ahFDPL3udvAUgPy4_Hf19HP46MZHw@mail.gmail.com>
Subject: Re: [PATCH] ACL supports to mqueue
From: Zhou Peng <ailvpeng25@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you James for your viewing.

* In general, it can give a more fine grained and flexible DAC to msg queue obj.
* NFSARK(A distro) wants all posix ipc objects to support ACL, including mqueue.
* Posix semphore and shmem both support ACL, but mqueue as one of the
three basic ipc doesn't.
* At least, it may save one note sentence for MQ_OVERVIEW(7)   ^_^
    "Linux does not currently (2.6.26) support the use of access
control lists (ACLs) for POSIX message queues."
    http://www.kernel.org/doc/man-pages/online/pages/man7/mq_overview.7.html

On Thu, Oct 20, 2011 at 11:33 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 20 Oct 2011, Zhou Peng wrote:
>
>> This patch adds ACL supports to mqueue filesystem.
>> Based on Linux 3.0.4.
>
> Why is this necessary, and who is planning to use it?
>
> Are any distros likely to enable this?
>
>
> - James
> --
> James Morris
> <jmorris@namei.org>
>



-- 
Zhou Peng
