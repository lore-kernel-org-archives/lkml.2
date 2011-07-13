Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab1GMHzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 03:55:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65065 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab1GMHzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 03:55:10 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B5A1E.4060604@gmail.com>
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
	<CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
	<4E1B5A1E.4060604@gmail.com>
Date: Wed, 13 Jul 2011 15:55:09 +0800
Message-ID: <CANudz+skU6AyPAgAJWLsoiY6DKKeYtWr2Ts3NJd_+AiGRXd+SA@mail.gmail.com>
Subject: Re: how to find a task through name faster?
From: loody <miloody@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi:

2011/7/12 Jiri Slaby <jirislaby@gmail.com>:
> On 07/11/2011 06:52 PM, loody wrote:
>> hi all:
>> I found a way to find a task I need by name, test,  as below:
>> for_each_process(task) {
>>     if(strcmp(task->comm, "test")
>>         printk(“%s[%d]\n”, task->comm, task->pid);
>> }
>>
>> But it is time-consuming to do so if I periodically want to know
>> whether "test" exist or not.
>> is there better way to do so?
>
> It depends on what you are trying to achieve. Maybe process accounting
> is what you want?
Would you mind to explain what is "process accounting"?
I ask this question cause I need to do something in my kernel driver
when a thread starting running.

is there any rule to assign a pid before starting a thread?
if there is a rule or range, such 100 ~200 for A type, 200~300 for B
type, I can focus on specific type of thread in that range instead of
searching everyone.

-- 
Regards,
