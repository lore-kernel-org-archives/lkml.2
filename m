Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0FVTwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:52:39 -0400
Received: from bay0-omc1-s1.bay0.hotmail.com ([65.54.190.12]:7048 "EHLO
	bay0-omc1-s1.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab0FVTwi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:52:38 -0400
Message-ID: <BAY134-W89C6A893D4CB1CC96E99FBDC40@phx.gbl>
X-Originating-IP: [209.236.250.213]
From: Xiachen Dong <xiachendong@hotmail.com>
To: <xiachendong@hotmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Possible methods for the kernel to terminate a process
Date: Tue, 22 Jun 2010 15:50:27 -0400
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Jun 2010 19:50:27.0955 (UTC) FILETIME=[29DBFC30:01CB1244]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We have a quick question. Besides sending signals, are there any other ways for the kernel to terminate a process?

We have such question because we try to kill a user space process by the shell command kill and we cannot kill it probably because it is in an un-interruptible sleep/wait. 

However, we still wish to be able to kill the user space process under this circumstance. To our knowledge of the kernel, if the kernel wants to kill a process when special event such as exception happens, it usually sends a signal to the process. We really cannot think of any other methods for a kernel to terminate a process.

Can anyone provide some hints on this? Is rebooting the machine the only solution to the problem?

Thanks,

Xiachen

 		 	   		  
_________________________________________________________________
Turn down-time into play-time with Messenger games
http://go.microsoft.com/?linkid=9734385