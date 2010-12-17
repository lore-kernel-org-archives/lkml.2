Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0LQWeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:34:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58639 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0LQWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:34:01 -0500
Date: Fri, 17 Dec 2010 14:33:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-16-14-56 uploaded (hugetlb)
Message-Id: <20101217143316.fa36be7d.randy.dunlap@oracle.com>
In-Reply-To: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 14:56:39 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.37-rc6:


# CONFIG_HUGETLBFS is not set
CONFIG_HUGETLB_PAGE=y


In file included from mmotm-2010-1216-1456/kernel/fork.c:36:
mmotm-2010-1216-1456/include/linux/hugetlb.h: In function 'hstate_inode':
mmotm-2010-1216-1456/include/linux/hugetlb.h:255: error: implicit declaration of function 'HUGETLBFS_SB'



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
