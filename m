Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1IEJOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:14:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52505 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1IEJOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:14:44 -0400
MIME-Version: 1.0
Date: Mon, 5 Sep 2011 14:44:43 +0530
Message-ID: <CAFPAmTTaq2Lz=eGgfG2-5U0M9aS_aZLNAANAVPZj6TEo9EdjGg@mail.gmail.com>
Subject: Is there any way to stop reclamation of file cache pages ?
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-fsdev@vger.rutgers.edu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am aware that mlocked pages can be stopped from being reclaimed
through the PFRA.

However, is there any method to stop reclamation of the page-cache
pages pertaining to
a single file's inode without mlocking ?

If I want to only use the open, read and write system calls and I want
to set specific file cache
pages to "non-reclaimable", how can I do so ?

Will the POSIX_FADV_WILLNEED option to the fadvise() system call solve
this problem ?

Thanks,
Kautuk.
