Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2EaIvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:51:12 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60252 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2EaIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:51:09 -0400
Message-ID: <4FC730FA.8080305@gmail.com>
Date: Thu, 31 May 2012 04:51:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Chris Wright <chrisw@sous-sol.org>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] security: kill security_task_fix_setuid()
References: <1338451199-15396-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.LRH.2.02.1205311841530.26474@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1205311841530.26474@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/31/12 4:42 AM), James Morris wrote:
> On Thu, 31 May 2012, kosaki.motohiro@gmail.com wrote:
>
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> commit 72fa5997 (move RLIMIT_NPROC check from set_user() to do_execve_common())
>> pointed out set*uid() failure can cause a security problem.
>> Thus, security_task_fix_setuid() potentially has the same issue. Any security
>> module shouldn't use it. This patch kills it completely.
>>
>> Luckily, any security module don't use it. then, this patch doesn't make any
>> userland visible change.
>
> Capabilities uses it.

Oops, I overlooked. Please ignore this patch. sorry.



