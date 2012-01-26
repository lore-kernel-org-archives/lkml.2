Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2AZWmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:42:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:45819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2AZWmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:42:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120126.173202.2207050843577467461.davem@davemloft.net>
References: <20120126.173202.2207050843577467461.davem@davemloft.net>
Date: Fri, 27 Jan 2012 00:41:59 +0200
Message-ID: <CALLzPKZbruWK2LFjqOZFimSfryPGJ2c95HhePiQ7+EsU2-jBjA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix the sparc32 mpilib build mess.
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:32 AM, David Miller <davem@davemloft.net> wrote:
>
> The long and short of it is that the longlong.h header added by
> the mpilib code is quite old and out of date.
>
> Here I've solved the clz_tab[] multiple definition problem as
> well as the outdated udiv_qrnnd() definition, but long term
> we should probably have a more uptodate longlong.h header
> provides at include/linux/longlong.h to avoid this kind of
> stuff in the future.
>
> It's a part of the libgcc interface and therefore has no
> business being tucked down deep under lib/foo/ somewhere.

Hello,

There is newer version of longlong.h in libgcrypt.
I will definitely try it...

- Dmitry
