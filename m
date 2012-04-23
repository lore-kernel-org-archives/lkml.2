Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2DWNih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:38:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56901 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWNig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
References: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
	<CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
Date: Mon, 23 Apr 2012 21:38:33 +0800
Message-ID: <CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
Subject: Re: [PATCH] RIFS cpu scheduler
From: mou Chen <hi3766691@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 9:13 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Mon, Apr 23, 2012 at 5:09 PM, mou Chen <hi3766691@gmail.com> wrote:
>> Here s the link of the cpu scheduler.
>> http://code.google.com/p/rifs-scheduler/downloads/list
>>
>> Patch the kernel firsrt, then replace the file /kernel/sched/rifs.c
>> with the new one that I attached.
>>
>> It is designed for interactivity and responsiveness. :-)
>>
> What is the relation between RIFS and BFS?

The SMP code is the same.The algorithum is different. :-)

I forget to fill the CC.Sorry. :-)
