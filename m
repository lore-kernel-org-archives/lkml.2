Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0IWRvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:51:32 -0400
Received: from xenotime.net ([72.52.115.56]:47781 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755771Ab0IWRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:51:31 -0400
Date: Thu, 23 Sep 2010 10:51:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org, Gao Yunpeng <yunpeng.gao@intel.com>
Cc: akpm@linux-foundation.org, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Re: mmotm 2010-09-22-16-11 uploaded (staging/spectra)
Message-Id: <20100923105127.75cf060d.rdunlap@xenotime.net>
In-Reply-To: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 16:12:09 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36-rc5:


drivers/staging/spectra/ffsport.c:659: error: implicit declaration of function 'blk_queue_ordered'
drivers/staging/spectra/ffsport.c:659: error: 'QUEUE_ORDERED_DRAIN_FLUSH' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
