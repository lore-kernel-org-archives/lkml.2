Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2KDT7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 14:59:49 -0500
Received: from smtp.getmail.no ([84.208.15.66]:55935 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2KDT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 14:59:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <op.wm9i6bu76426ze@localhost.localdomain>
References: <op.wm9b7wnn6426ze@localhost.localdomain>
 <op.wm9i6bu76426ze@localhost.localdomain>
Subject: Re: sched: SCHED_DEADLINE v6
To: juri.lelli@gmail.com, linux-kernel@vger.kernel.org
Date: Sun, 04 Nov 2012 20:30:16 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wm9kgqki6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody knows? This is really obscure for an EDF patch. Making things a bit  
more accessible should be a priority. I think a lot of enthusiasts would  
like to have smooth control over stuff, without windows-jitter. If you can  
do a robot arm, jitter-free with this, then I am very interested.

uwaysi@Millennium:~/Kildekode/sched_deadline-schedtool-dl$ ./schedtool -E
-t 500:1000 3718
ERROR: could not set PID 3718 to E: SCHED_DEADLINE - Function not
implemented
uwaysi@Millennium:~/Kildekode/sched_deadline-schedtool-dl$

On Sun, 04 Nov 2012 20:02:25 +0100, Uwaysi Bin Kareem
<uwaysi.bin.kareem@paradoxuncreated.com> wrote:

> How does the modified schedtool work? There is no updated documentation.
>
> http://gitorious.org/sched_deadline/schedtool-dl/commits/latest/2.6.36-dl-V3
>
> If anyone could give an example of a 1000uS period / 500uS time, with  
> schedtool, or any other relevant information.
> Most examples online use parameters that are no longer supported.
>
> Peace Be With You.
