Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0KFPup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:50:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62555 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0KFPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:50:43 -0400
Date: Sat, 6 Nov 2010 08:49:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 15/16 v2] pramfs: test module
Message-Id: <20101106084940.d3672f06.randy.dunlap@oracle.com>
In-Reply-To: <4CD51958.6040308@gmail.com>
References: <4CD51958.6040308@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Nov 2010 10:01:12 +0100 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Test module.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/fs/pramfs/pramfs_test.c linux-2.6.36/fs/pramfs/pramfs_test.c
> --- linux-2.6.36-orig/fs/pramfs/pramfs_test.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/fs/pramfs/pramfs_test.c	2010-09-14 18:49:52.000000000 +0200
> @@ -0,0 +1,49 @@
> +/*
> + * FILE NAME fs/pramfs/namei.c
> + *
> + * BRIEF DESCRIPTION
> + *
> + * Pramfs test module.


Wrong FILE NAME.  Better to just omit it completely.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
