Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1C2M7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:59:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44348 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1C2M7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lSLVGAZEx8BER67L5OnowbQa482wJbVwkMFK90IY8UDatlLFGOWf2MAyzsavd+GCDq
         SIow8gyTFqM8gdnx06ddoSvcRzUWu2SXk1MNXamuW9FTCPFJIOqxz8q0rnBi2oZji907
         B+fo/oFRHJ+h2097ANSPKLIfQk/fYSETdtjuA=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] s3c2440: mini2440: Use leds-gpio driver for board leds handling.
Date: Tue, 29 Mar 2011 15:58:26 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-anarsoul; KDE/4.6.1; i686; ; )
Cc: Marek Belisko <marek.belisko@open-nandra.com>, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <AANLkTi=RW0o=+hXcO0Y04nq10QEd=hWY0Nzc0enJ=Tr7@mail.gmail.com> <1301392380-9022-1-git-send-email-marek.belisko@open-nandra.com>
In-Reply-To: <1301392380-9022-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291558.26624.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011 12:53:00 Marek Belisko wrote:
> Intention of this patch is convert existing usage of leds-s3c24xx driver
> to use generic gpio-leds driver. Leds are separated to 2 devices.
> First device handle 4 available leds. Second device is used to drive
> LCD backlight. Backlight can be controlled via parameter b so we need
> separate device which is registered or not depending on parameter.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

You also need to remove mach/leds-gpio.h include, you don't need it anymore, 
right? Rest part looks good for me.

Regards
Vasily
