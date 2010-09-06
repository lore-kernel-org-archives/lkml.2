Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0IFJ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:28:44 -0400
Received: from ozlabs.org ([203.10.76.45]:49571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab0IFJ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:28:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mutex: add to kernel-locking docbook
Date: Mon, 6 Sep 2010 18:58:33 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
References: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
In-Reply-To: <20100902154816.6cc2f9ad.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061858.34619.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 08:18:16 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc notation in linux/mutex.h and kernel/mutex.c,
> then add these 2 files to the kernel-locking docbook as the
> Mutex API reference chapter.
> 
> Add one API function to mutex-design.txt and correct a typo in
> that file.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
