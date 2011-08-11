Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1HKHxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:53:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HKHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:53:30 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1311147490.10091.1.camel@phoenix>
References: <1311147490.10091.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 11 Aug 2011 15:52:43 +0800
Message-ID: <CAF+7xWmkegXQ6u+iVGgkiUuUxJJrAXArQfmq4-4y6ZZuOEqRPg@mail.gmail.com>
Subject: Re: [PATCH] Input: mpu3050 - call input_free_device() in
 mpu3050_probe() error handling
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joseph Lai <joseph_lai@wistron.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/20 Axel Lin <axel.lin@gmail.com>:
> From 3dcc899388d98a68c22d14b3149d3cc472f8d2fa Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Wed, 20 Jul 2011 15:34:33 +0800
> Subject: [PATCH] Input: mpu3050 - correct call to input_free_device
>
> input_free_device() should be used if input_register_device() was not called
> yet or if it failed.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
hi Dmitry,
Seems this fix is not yet upstream.

Regards,
Axel
