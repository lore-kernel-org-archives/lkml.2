Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0HLUPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:15:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab0HLUPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:15:01 -0400
Date: Thu, 12 Aug 2010 13:14:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s3fb: add DDC support
Message-Id: <20100812131421.bb2839f8.akpm@linux-foundation.org>
In-Reply-To: <201008112218.11535.linux@rainbow-software.org>
References: <201008112218.11535.linux@rainbow-software.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 22:18:09 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> Add I2C support for the DDC bus to s3fb driver. This is only bus support,
> driver does not use EDID.
> 
> Tested on Trio64V+, Trio64V2/DX, Virge (2 cards), Virge/DX (4 cards) and
> Trio3D/2X (3 cards) with i2cdetect and decode-edid.
> 
> Will probably not work on Trio32 - my 2 cards have DDC support in BIOS that
> looks different from the other cards but the DDC pins on the VGA connector
> are not connected.
> 
> Virge/GX, Virge/GX2 and Virge/VX are untested.
> 
> ...
>
> +#ifdef CONFIG_FB_S3_DDC

Now please send us the drivers/video/Kconfig hunk as well ;)

FB_S3_DDC might need to depend on I2C.
