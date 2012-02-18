Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2BRHMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 02:12:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46326 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2BRHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 02:12:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAOGqxeWjtr=SOY83ZFEdwJXXatqLLEN6SHre9-0DfeJfcyBhKQ@mail.gmail.com>
References: <CAOGqxeWjtr=SOY83ZFEdwJXXatqLLEN6SHre9-0DfeJfcyBhKQ@mail.gmail.com>
Date: Sat, 18 Feb 2012 15:12:22 +0800
Message-ID: <CAJd=RBAmVcJBS_WdUwBYVDAOz+rBvxNER=Q1r7Q0cyuWiQ1gcQ@mail.gmail.com>
Subject: Re: Stack unwind across signal frame
From: Hillf Danton <dhillf@gmail.com>
To: Alan Cooper <alcooperx@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 5:13 AM, Alan Cooper <alcooperx@gmail.com> wrote:
> This problem ends up breaking pthread cleanup for C++ programs because
> the cleanup is done using a class with the expectation that the
> destructor will be called when the thread gets canceled by a cancel
> signal. This seems like a big problem for all current MIPS kernels so
> I was wondering if I'm missing something?
>
> If this is correct, then it seems like the best solution would be to
> add the VDSO eh_frame info to MIPS.
>
Feel free to send a patch after testing;)
