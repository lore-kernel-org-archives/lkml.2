Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2ADEwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:52:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56352 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2ADEwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAFPAmTSi0i4q+mZ3KwVpEXiSoZ0=BeWUQgeSghd0PWPN+NojfA@mail.gmail.com>
References: <1324639362-18220-1-git-send-email-consul.kautuk@gmail.com>
	<CAFPAmTSi0i4q+mZ3KwVpEXiSoZ0=BeWUQgeSghd0PWPN+NojfA@mail.gmail.com>
Date: Wed, 4 Jan 2012 10:22:48 +0530
Message-ID: <CAFPAmTR8hNzF0D+-XhbWDuhXosZLKj7xznr8jpg3x0=9XQFHDw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mips: fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> However, since the generic part of the kernel(mm/filemap.c) now
> supports killable and
> retryable page fault handling, I thought that this change would be
> valid for MIPS too.


Did anyone get a chance to review this patch?
