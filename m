Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0KSTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:09:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51426 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0KSTJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R/ihlrV/qyE24YcRRi7X351byZT7eiMA1eV4bX6BHYBF5/y7Cn5P5i4hD2DxHux8Kd
         6hho3cMP+LnmLpXCDg6jBrz6VkfeXayH+YpPZwOOs5g4esC2LtSLgrX6zuZdOziqTfRa
         shOUB8/FWUwrUXb6ZYfnOP7wGiClYPJQ/qR/4=
MIME-Version: 1.0
In-Reply-To: <1290039615-23407-1-git-send-email-ccross@android.com>
References: <1290039615-23407-1-git-send-email-ccross@android.com>
Date: Fri, 19 Nov 2010 20:08:48 +0100
Message-ID: <AANLkTimjJVw3ZA1F5VEJPaJwwK0FyH=XXc+vkau5zzAk@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: timer: Separate clocksource and sched_clock
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/18 Colin Cross <ccross@android.com>:

> tegra_clocksource_read should not use cnt32_to_63, wrapping is
> already handled in the clocksource code.  Move the cnt32_to_63
> into the sched_clock function, and replace the use of clocksource
> mult and shift with a multiplication by 1000 to convert us to ns.
>
> Change-Id: Ica1158c3fbed0ba53391f7db61180129a957511d

The Linux kernel does not use Gerrit...

> Signed-off-by: Colin Cross <ccross@android.com>

Apart from that:
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
