Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1HPFlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:41:47 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33730 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1HPFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <1313454275-5604-2-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
	<1313454275-5604-2-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 08:41:45 +0300
X-Google-Sender-Auth: VZHa7PM2aDfQcZ-8TUDG8aYAEx0
Message-ID: <CAOJsxLHAh5dG89Bvi01Qx5ysPRwBfjjQgHiwSnxABKyaxsLNfA@mail.gmail.com>
Subject: Re: [PATCH 2/9] Staging: Winbond: Fix pointer style in wb35tx.c.
From: Pekka Enberg <penberg@kernel.org>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:24 AM, Akshay Joshi <me@akshayjoshi.com> wrote:
> Pointers should be prefixed with a single space according to the kernel
> coding style.
>
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
