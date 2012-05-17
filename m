Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2EQFU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:20:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65398 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2EQFU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
Date: Thu, 17 May 2012 10:50:24 +0530
Message-ID: <CAM=Q2csTziLb0niCTj6oW9G=BPa2VWN58rW2jF-A1VJKXwNfCQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Some fault i2c device may hold the sda/scl line and cause i2c driver
> wait in the BUS busy loop. This patch breaks this potential dead
> loop.
How about using a non-busy loop while you are at it.

>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9291 526b6c2d-f592-4532-a319-5dd88ccb003d
