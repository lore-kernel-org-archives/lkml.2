Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2B1Arp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:47:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61509 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2B1Aro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:47:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.gortmaker@gmail.com designates 10.68.224.230 as permitted sender) smtp.mail=paul.gortmaker@gmail.com; dkim=pass header.i=paul.gortmaker@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330389383.16334.22.camel@joe2Laptop>
References: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
	<1330389383.16334.22.camel@joe2Laptop>
Date: Mon, 27 Feb 2012 19:47:43 -0500
X-Google-Sender-Auth: 86JTQ9Ic0UM8Jgp2jCG1iX3PFOE
Message-ID: <CAP=VYLqnRXd_LR67+xz2k6YKX7YJiA7cgYwZ8pN3aQMgDN0dzw@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: do not try to sanity test cover letters
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Joe Perches <joe@perches.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 7:36 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-02-27 at 19:29 -0500, Paul Gortmaker wrote:
>> One possibly common workflow is this:
>>
>>       git format-patch -o mypatches --cover-letter ^start end
>>       ./scripts/checkpatch.pl mypatches/*
>
> I use a script for this and don't put the check
> in checkpatch but put the check in bash.

Sure, and I can do the same.  But my question to you is whether
you think the above is a common workflow, and if the false positives
that it generates will decrease the number of people likely to make
using it a part of their routine?

Paul.
--

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
