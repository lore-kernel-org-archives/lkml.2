Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab2BPP0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:26:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52161 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2BPP0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <1329403542-32606-1-git-send-email-danny.kukawka@bisect.de>
References: <1329403542-32606-1-git-send-email-danny.kukawka@bisect.de>
Date: Thu, 16 Feb 2012 23:26:45 +0800
Message-ID: <CAN1soZzQyQpC4V0HhfpA6gGfziBBEEnW=f60YAKjmbKW4APs=w@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-pxa/: included linux/gpio.h twice
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, Danny Kukawka <dkukawka@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:45 PM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> arch/arm/mach-pxa/pxa25x.c and arch/arm/mach-pxa/saarb.c
> included 'linux/gpio.h' twice, remove the duplicates.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  arch/arm/mach-pxa/pxa25x.c |    1 -
>  arch/arm/mach-pxa/saarb.c  |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
>
Applied. Thanks
