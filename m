Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872Ab2B2Ny3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:54:29 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59747 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030553Ab2B2Ny1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:54:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.92.227 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <1324385014-30725-1-git-send-email-vhtnguyen@apm.com>
References: <1324385014-30725-1-git-send-email-vhtnguyen@apm.com>
Date: Wed, 29 Feb 2012 08:54:26 -0500
Message-ID: <CA+5PVA5SZmeEdBF0XvNmvCwroCKs1EwdWNbd_nwyEDCoZGHo2Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] powerpc/44x: The bug fixed support for APM821xx SoC
 and Bluestone board
From: Josh Boyer <jwboyer@gmail.com>
To: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 7:43 AM, Vinh Nguyen Huu Tuong
<vhtnguyen@apm.com> wrote:
> This patch consists of:
> - Fix the pvr mask for checking pvr in cputable.c
> - Fix the cpu name as consistent with cpu name is describled in dts file
>
> Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
> ---

I was waiting to see if you would submit a new series with patch 3/3 fixed for
the comments I made.  Seems you haven't yet or I missed it entirely.  For now,
I'll take this patch as it's stand-alone.  The DTS and PCI driver patches will
need to be submitted together again.

josh
