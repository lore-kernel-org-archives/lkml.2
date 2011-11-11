Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1KKDmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 22:42:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1KKDmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 22:42:21 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Date: Thu, 10 Nov 2011 19:41:59 -0800
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
References: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
In-Reply-To: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111101941.59570.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thursday, November 10, 2011 06:11:59 PM Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> drivers/input/keyboard/Kconfig between commit 007205aa47e9 ("input:
> samsung-keypad: Add HAVE_SAMSUNG_KEYPAD config option") from the s5p
> tree and commit 5862c02d745f ("Input: samsung-keypad - enable compiling
> on other platforms") from the input tree.
> 
> I have fixed it up (probably incorrectly - see below) and can carry the
> fix as necessary.

Please drop the whole HAVE_SAMSUNG_KEYPAD thing; HAVE_CLK is all
this driver needs. Expanding beyond Samsung will allow greater
compile coverage.

Thanks.

-- 
Dmitry
