Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2IEBSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:18:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36313 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2IEBSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <1345217308.3708.35.camel@gandalf.local.home>
References: <1345204994-5400-1-git-send-email-elezegarcia@gmail.com>
	<1345217308.3708.35.camel@gandalf.local.home>
Date: Tue, 4 Sep 2012 22:18:09 -0300
Message-ID: <CALF0-+WGTLQJQ-k3s11BjwpDnpJqByQuLEPttan+n4ecs2MQ5g@mail.gmail.com>
Subject: Re: [RFC PATCH v2] trace: Move trace event enable from fs_initcall to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, tim.bird@am.sony.com,
        lizefan@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 8/17/12, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-08-17 at 09:03 -0300, Ezequiel Garcia wrote:
>> This patch splits trace event initialization in two stages:
>>  * ftrace enable
>>  * sysfs event entry creation
>>
>> This allows to capture trace events from an earlier point
>> by using 'trace_event' kernel parameter and is important
>> to trace boot-up allocations.
>>
>
> This is much better, I'll give it some tests and add it to my 3.7 queue.
>

Ping? Will you add this to your tree?

Thanks!
Ezequiel.
