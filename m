Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab0HSFAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:00:15 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60708 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0HSFAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:00:13 -0400
Message-ID: <4C6CBA56.9020909@in.ibm.com>
Date: Thu, 19 Aug 2010 10:30:06 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, dhowells@redhat.com
Subject: [s390] Build failure with latest 2.6.36-rc1 git (sys_execve)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest 2.6.36-rc1 git fails to build on a s390 with

arch/s390/kernel/process.c:272: error: conflicting types for 'sys_execve'
arch/s390/kernel/entry.h:45: error: previous declaration of 'sys_execve' was here
make[1]: *** [arch/s390/kernel/process.o] Error 1

This error was introduced via commit :

commit d7627467b7a8dd6944885290a03a07ceb28c10eb
Make do_execve() take a const filename pointer

I guess the corresponding definition of sys_execve()
in arch/s390/kernel/entry.h also needs an update.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

