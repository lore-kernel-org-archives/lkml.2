Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab1GMJVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:21:09 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35156 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab1GMJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:21:07 -0400
Message-ID: <4E1D637D.1050004@gmail.com>
Date: Wed, 13 Jul 2011 11:21:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: loody <miloody@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to find a task through name faster?
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com> <CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com> <4E1B5A1E.4060604@gmail.com> <CANudz+skU6AyPAgAJWLsoiY6DKKeYtWr2Ts3NJd_+AiGRXd+SA@mail.gmail.com>
In-Reply-To: <CANudz+skU6AyPAgAJWLsoiY6DKKeYtWr2Ts3NJd_+AiGRXd+SA@mail.gmail.com>
X-Enigmail-Version: 1.2pre
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 09:55 AM, loody wrote:
> hi:
> 
> 2011/7/12 Jiri Slaby <jirislaby@gmail.com>:
>> On 07/11/2011 06:52 PM, loody wrote:
>>> hi all:
>>> I found a way to find a task I need by name, test,  as below:
>>> for_each_process(task) {
>>>     if(strcmp(task->comm, "test")
>>>         printk(“%s[%d]\n”, task->comm, task->pid);
>>> }
>>>
>>> But it is time-consuming to do so if I periodically want to know
>>> whether "test" exist or not.
>>> is there better way to do so?
>>
>> It depends on what you are trying to achieve. Maybe process accounting
>> is what you want?
> Would you mind to explain what is "process accounting"?

http://lmgtfy.com/?q=process+accounting+linux

> I ask this question cause I need to do something in my kernel driver
> when a thread starting running.

No, it doesn't work that way. You have to explain what exactly you want
to do (i.e. show sources and describe) so that people can actually help you.

regards,
-- 
js
