Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab1IHA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:27:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37518 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab1IHA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:27:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 09:26:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-fsdev@vger.rutgers.edu, linux-kernel@vger.kernel.org
Subject: Re: Is there any way to stop reclamation of file cache pages ?
Message-Id: <20110908092633.2fcc01d7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAFPAmTTaq2Lz=eGgfG2-5U0M9aS_aZLNAANAVPZj6TEo9EdjGg@mail.gmail.com>
References: <CAFPAmTTaq2Lz=eGgfG2-5U0M9aS_aZLNAANAVPZj6TEo9EdjGg@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 14:44:43 +0530
"kautuk.c @samsung.com" <consul.kautuk@gmail.com> wrote:

> Hi,
> 
> I am aware that mlocked pages can be stopped from being reclaimed
> through the PFRA.
> 
> However, is there any method to stop reclamation of the page-cache
> pages pertaining to
> a single file's inode without mlocking ?
> 
> If I want to only use the open, read and write system calls and I want
> to set specific file cache
> pages to "non-reclaimable", how can I do so ?
> 

For this kind of question, you should explain why you can't use mlock.

> Will the POSIX_FADV_WILLNEED option to the fadvise() system call solve
> this problem ?
> 

I think no.

Thanks,
-Kame

