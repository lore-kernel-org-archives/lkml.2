Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0DMPdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:33:11 -0400
Received: from smtp.getmail.no ([84.208.15.66]:55605 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0DMPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:33:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
X-PMX-Version: 5.5.3.366731, Antispam-Engine: 2.7.0.366912,
 Antispam-Data: 2010.4.13.151814
To: linux-kernel@vger.kernel.org
Subject: Re: Optimal refresh rate for minimal psychovisual noise,
 and tuning the kernel for it.
References: <op.u900zpso6426ze@pxu> <op.u92oscfg6426ze@pxu>
 <op.vaa3yqo56426ze@pxu>
Date: Tue, 13 Apr 2010 17:33:08 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.va3xhie06426ze@millennium>
In-reply-to: <op.vaa3yqo56426ze@pxu>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 04:02:40 +0200, Uwaysi Bin Kareem  
<uwaysi.bin.kareem@paradoxuncreated.com> wrote:

> I summed up the main points of this, in an article. Please do read.
>
> http://www.paradoxuncreated.com/articles/Millennium/Millennium.html
>
> Peace Be With You.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hello.

In an attempt to follow up, on this article, I would like to see if I can  
further tune the system, with renice
or chrt (or schedtool.)

So I was wondering if you, or if you can point me to a place, where I can  
find information on common processes in a linux system, (I am using Ubuntu  
LL at the moment), and which of these are related to audiovisual  
performance, and which of these I can safely renice to 14, without  
affecting audiovisual performance. I would also like to know, if I should  
change the scheduling type, of any of the processes.

 From what I understand of processing and scheduling, some processes should  
run first, aka realtime, and consume the cpu it needs, and then "casual"  
tasks, who do regular duties, not related to audiovisual performance, for  
a certain timeslice, or virtual cpu, and then the intensive tasks, who  
consume as much cpu as they can.

I would like to try and follow such a mindset with renicing and scheduling  
tweaks.

Peace Be With you.


