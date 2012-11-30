Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2K3Gi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:38:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50166 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2K3GiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:38:25 -0500
Message-ID: <50B85456.9040807@gmail.com>
Date: Fri, 30 Nov 2012 14:38:14 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com
CC: Shan Wei <shanwei88@gmail.com>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        cl@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v4 7/9] trace: use this_cpu_ptr per-cpu helper
References: <50A1A800.3020102@gmail.com> <50A5FA84.8080106@gmail.com>
In-Reply-To: <50A5FA84.8080106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shan Wei said, at 2012/11/16 16:34:
> Shan Wei said, at 2012/11/13 9:53:
>> From: Shan Wei <davidshan@tencent.com>
>>
>> typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
>> But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
>> As well-known, the value of &buffer is equal to &buffer[0].
>> so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast. 
>>
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
> 
> Steven Rostedt,  would you like to pick it up to your tree?

ping......................

