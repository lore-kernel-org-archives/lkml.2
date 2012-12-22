Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab2LVNYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:24:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43553 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LVNYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:24:39 -0500
Date: Sat, 22 Dec 2012 08:24:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121222132419.GB2936@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <20121222024225.GG3468@phenom.dumpdata.com>
 <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 07:01:21PM -0800, H. Peter Anvin wrote:
> Earlyprintk please?

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading vmlinuz.......................................................................
Loading initramfs.cpio.gz.....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
Probing EDD (edd=off to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.


Interestingly enough I only see this on any AMD machine - different
motherboards, different memory configurations.

And also in a HVM guest running on an AMD machine. If it runs on Intel
it works just fine.

