Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab1GKR5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:57:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63879 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab1GKR5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B3816.2030606@genband.com>
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com>
	<CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
	<4E1B3816.2030606@genband.com>
Date: Tue, 12 Jul 2011 01:57:20 +0800
Message-ID: <CANudz+vvXrw=4+tk6z8GW+2rW-ZsogN0XGcozLSyY-dJ_SoHdw@mail.gmail.com>
Subject: Re: how to find a task through name faster?
From: loody <miloody@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi:

2011/7/12 Chris Friesen <chris.friesen@genband.com>:
> On 07/11/2011 10:52 AM, loody wrote:
>>
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

Thanks for your reply

> The names of tasks isn't indexed in any way so the above is about as good as
> it gets if that's all the information you have.

actually, I only have the name for searching, since the thread start
 and finish periodically, pid of it will change dynamically. If I save
the pid, next time it will change and be no use to me
>
> One common way around that is to store the PID in a file somewhere at
> startup.  Then you can look in the file and see if that PID is present and
> check "task->comm" to make sure it's what you expect.  This saves having to
> search through all tasks.
>
> Chris


-- 
Regards,
