Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1KKDmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 22:42:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42441 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1KKDmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 22:42:49 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Date: Thu, 10 Nov 2011 19:42:28 -0800
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
References: <20111111131147.3f7ab8c9f14a7d87cc83b5ac@canb.auug.org.au>
In-Reply-To: <20111111131147.3f7ab8c9f14a7d87cc83b5ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111101942.28673.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 10, 2011 06:11:47 PM Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> drivers/input/keyboard/samsung-keypad.c between commit 532f74540134
> ("input: samsung-keypad: Add device tree support") from the s5p tree and
> commit 400bf2995be6 ("Input: samsung-keypad - switch to using
> SIMPLE_DEV_PM_OPS") from the input tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.


Yep, looks good, thanks Stephen.

-- 
Dmitry
