Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0J3PSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:18:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab0J3PSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikXAde1yLZkB80GOjWu-sFZAvv0SL566rWssD1k@mail.gmail.com>
References: <4CCBC8B1.2080808@in.ibm.com> <AANLkTimE=uzwhDMz_-jVWKyb9NAONGuVvVo5KbjkkZVu@mail.gmail.com>
 <AANLkTikXAde1yLZkB80GOjWu-sFZAvv0SL566rWssD1k@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Oct 2010 08:17:41 -0700
Message-ID: <AANLkTinBNAUAh5uZ9V82zjv4uWH1UTXbUA2rPy1d2pCk@mail.gmail.com>
Subject: Re: [s390] 2.6.36-git14 build break - fs/compat.c :631
 (PAGE_CACHE_MASK undeclared)
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 1:12 AM, wu zhangjin <wuzhangjin@gmail.com> wrote:
>
> (Seems Linus added that patch, add him in this loop)

My bad. It was such a totally obvious and trivial patch, and it
compiled for me on x86-64. Too bad our header include dependencies are
such a mess, and actually change from one architecture to another.

I'd love to fix up the header mess, but that's not going to happen. So
I'll take the <linux/filemap.h> addition.

Thanks,

                                  Linus
