Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1HLBtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:49:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1HLBtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110723154916.391682000@linutronix.de>
References: <20110723154916.391682000@linutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 11 Aug 2011 21:48:55 -0400
X-Google-Sender-Auth: AJmeBGqQV1jwG5I_c7mLi-vRiEQ
Message-ID: <CAMjpGUd0gN9Gb7jpMOoEN+w-DxxUhW5wgP49-gAqW8d4sYBw0Q@mail.gmail.com>
Subject: Re: [patch] blackfin: Fixup bogus ioresource init
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Javier Herrero <jherrero@hvsistemas.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:51, Thomas Gleixner wrote:
> +               .flags  = (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE |
> +                          | IORESOURCE_IRQ_SHAREABLE),

this introduced a syntax error (two "|" back to back).  ive pushed out
a fix to my next branch with it.
-mike
