Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1G0G7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:59:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56361 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1G0G7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110723154916.391682000@linutronix.de>
References: <20110723154916.391682000@linutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 26 Jul 2011 23:58:57 -0700
X-Google-Sender-Auth: QE3B8J67--Iv7PBmuqEK4ftR_0w
Message-ID: <CAMjpGUdDYQiX+UwWbKYsGWRZv1q=XL7m8G=kz_Rk5cgL+oAo_Q@mail.gmail.com>
Subject: Re: [patch] blackfin: Fixup bogus ioresource init
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Javier Herrero <jherrero@hvsistemas.es>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 08:51, Thomas Gleixner wrote:
> IRQF_SHARED is not part of the IORESOURCE_IRQ bits. It's expressed by
> IORESOURCE_IRQ_SHAREABLE.
>
> IORESOURCE_IRQ_HIGHEDGE and IRQF_TRIGGER_HIGH are contradicting
> values, an interrupt can hardly be configured for both level and edge
> at the same time. This was introduced in commit 45138439(Blackfin
> arch: flash memory map and dm9000 resources updating) of course
> without any hint in the changelog what the heck this is supposed to
> do.

makes sense to me.  if Javier doesnt have a problem with it, i'll pick
it up in a while (traveling atm).
-mike
