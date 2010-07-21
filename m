Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0GUKkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 06:40:49 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56554 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0GUKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 06:40:47 -0400
Message-ID: <4C46CEA3.7040503@in.ibm.com>
Date: Wed, 21 Jul 2010 16:10:35 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [-next July 21] s390 build failure : kernel/workqueue.o
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next fails to build on a s390 box with

  CC      kernel/workqueue.o
kernel/workqueue.c: In function 'init_workqueues':
kernel/workqueue.c:3525: error: negative width in bit-field '<anonymous>'
make[1]: *** [kernel/workqueue.o] Error 1

Yesterday's next was good.
The following patches added/changed the BUILD_BUG_ON() statement.

bdbc5dd7de5d07d6c9d3536e598956165a031d4c
        workqueue: prepare for WQ_UNBOUND implementation
7a22ad757ec75186ad43a5b4670fa7423ee8f480
         workqueue: carry cpu number in work data once execution starts

I have gcc version 4.3.2 installed on the system.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

