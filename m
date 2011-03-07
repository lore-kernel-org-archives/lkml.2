Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1CGIPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:15:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1CGIPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kXpvgbolu6+4+OhvRf4YoZGrYFdStF9gJf6JOzc3FQb0LN28W9/DNKx7OeM2BROPqI
         3qkuIJkrj2lbOOZyoemaro7HVrEJ0cPYT0UUtvKlVQkIjfTZIA/pNRnOabCEmxPUsKa5
         Ont+Y9KK6q87cVE9si0V76dzHAWlS9iTbPZoo=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/2] ARM: s3c24xx: Switch to common GPIO controlled UDC pullup implementation
Date: Mon, 7 Mar 2011 10:15:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r1-anarsoul; KDE/4.6.1; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1299483720-18175-1-git-send-email-lars@metafoo.de> <1299483720-18175-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1299483720-18175-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103071015.17295.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 March 2011 09:42:00 Lars-Peter Clausen wrote:
> Currently all boards using the s3c2410_udc driver use a GPIO to control the
> state of the pullup, as a result the same code is reimplemented in each
> board This patch changes these boards to use the common implementation for
> GPIO controlled pullup in the UDC driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2410/mach-h1940.c    |   24 +-----------------------
>  arch/arm/mach-s3c2410/mach-n30.c      |   21 +--------------------
>  arch/arm/mach-s3c2412/mach-smdk2413.c |   24 +-----------------------
>  arch/arm/mach-s3c2440/mach-gta02.c    |   22 ++--------------------
>  arch/arm/mach-s3c2440/mach-mini2440.c |   24 +-----------------------
>  arch/arm/mach-s3c2440/mach-rx1950.c   |   21 +--------------------
>  6 files changed, 7 insertions(+), 129 deletions(-)

For h1940 and rx1950 parts:

Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>
