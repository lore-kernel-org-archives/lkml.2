Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2JSBNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:13:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58826 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2JSBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <1350580854.2680.31.camel@lorien2>
References: <1350574699-6419-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVMHiamXLk8eJr7SgMZRaYt=JdmseG35iQZAJ5=BsHTXgA@mail.gmail.com>
	<1350580854.2680.31.camel@lorien2>
Date: Fri, 19 Oct 2012 09:13:36 +0800
Message-ID: <CACVXFVNDM0RcAb0C3h9_2_idSmz5gC3U6orv74s1ypUVWX42gg@mail.gmail.com>
Subject: Re: [PATCH] lib/dma-debug.c: fix __hash_bucket_find
From: Ming Lei <ming.lei@canonical.com>
To: shuah.khan@hp.com
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kubakici@wp.pl>, shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 1:20 AM, Shuah Khan <shuah.khan@hp.com> wrote:

> Thanks for finding and fixing the problem. This fixes the problem
> Fengguang Wu reported: adding him to the thread.
>
> https://lkml.org/lkml/2012/10/14/233
>
> I have a reliable test case and test system that reproduces the problem.
> Re-tested it with and without patch and didn't see the warning with your
> patch.
>
> That said, this patch is malformed and didn't apply cleanly.
> You have my
>
> Tested-by: Shuah Khan <shuah.khan@hp.com>

OK, I will submit it again for merge.

Thanks,
--
Ming Lei
