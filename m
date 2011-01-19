Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1AST4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:56:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1AST43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:56:29 -0500
Date: Wed, 19 Jan 2011 20:55:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110119195546.GJ9506@random.random>
References: <web-442414153@zbackend1.aha.ru>
 <20110119155954.GA2272@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119155954.GA2272@kryptos.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 04:59:54PM +0100, Borislav Petkov wrote:
> Adding some more parties to CC.

Thanks for adding me to CC.

Werner, could you send me the vmlinux (or bzImage) of the exact kernel
that crashed (don't rebuild), otherwise I don't know where it
crashed...

Crash on booting sounds like it's very reproducible, that's great so
we fix it immediately (maybe it's related to highpte or some other
.config difference that wasn't exercised). Probably 32bit THP got 0.1%
of the testing that 64bit version had... (if I don't get a
vmlinux/bzImage of the kernel that crashed soon, I'll try to reproduce
on a VM with the .config attached, I've no host with 32bit userland
anymore..).
