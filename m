Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1KTJag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 04:30:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60625 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1KTJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 04:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <4EC7AFDF.6030009@gmail.com>
References: <4EC7AFDF.6030009@gmail.com>
Date: Sun, 20 Nov 2011 17:30:30 +0800
Message-ID: <CAM_iQpWru-yPVNVLSi1CnSKtDDEtUhyWJD=WOmTkmcYQXFHDqg@mail.gmail.com>
Subject: Re: [PATCH] Fixed use of rounddown_pow_of_two in ramoops
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 9:32 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> The return value of rounddown_pow_of_two wasn't evaluated, so the
> operation was a no-op.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
