Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1JGVVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:21:43 -0400
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:42956 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209Ab1JGVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <4E8F683D.9020604@xenotime.net>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au> <4E8F683D.9020604@xenotime.net>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 7 Oct 2011 14:21:19 -0700
Message-ID: <CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> Add <linux/stat.h> to fix build errors:

When did this break?  I build ipath in my test config all the time...

 - R.
