Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2GEUUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:20:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53448 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2GEUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <201207051240.32157.arnd@arndb.de>
References: <201207051240.32157.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 13:19:43 -0700
X-Google-Sender-Auth: qgLT_0LWy0p4BI33nG-5kMPf3Rg
Message-ID: <CA+55aFyAJJVCH_0oBhjQujH+M1qEa-CZdPLSfnizVCPbtUu1EQ@mail.gmail.com>
Subject: Re: ARM: SoC fixes for 3.5-rc
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 5:40 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

This is not a valid pull address. Please just use

    git://git.kernel.org/

rather than the internal address you use to push to and that isn't
publicly available.

               Linus
