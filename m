Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0J3H0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 03:26:44 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40703 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0J3H0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 03:26:42 -0400
Message-ID: <4CCBC8B1.2080808@in.ibm.com>
Date: Sat, 30 Oct 2010 12:56:41 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100903)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-s390@vger.kernel.org
Subject: [s390] 2.6.36-git14 build break - fs/compat.c :631 (PAGE_CACHE_MASK
 undeclared)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest 2.6.36 git [commit 44234d0c46...] fails to build on s390x with following error :

fs/compat.c: In function compat_rw_copy_check_uvector:
fs/compat.c:631: error: PAGE_CACHE_MASK undeclared (first use in this function)
fs/compat.c:631: error: (Each undeclared identifier is reported only once
fs/compat.c:631: error: for each function it appears in.)
make[1]: *** [fs/compat.o] Error 1

The code in question was added via following commit:

commit 435f49a518c78eec8e2edbbadd912737246cbe20
readv/writev: do the same MAX_RW_COUNT truncation that read/write does

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

