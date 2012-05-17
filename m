Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966090Ab2EQLan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:30:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52880 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781Ab2EQLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:30:41 -0400
MIME-Version: 1.0
In-Reply-To: <1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
Date: Thu, 17 May 2012 17:00:40 +0530
Message-ID: <CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing I2C
 transfer if MEN bit is reset unexpectedly.
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Correct I2C transfer may fail because interrupt status bits XMTSERV and
> RCVSERV are not checked when MCOMP interrupt is handled.
>
Could you expand MCOMP?
