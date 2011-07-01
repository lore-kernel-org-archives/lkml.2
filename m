Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1GALzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:55:43 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:32871 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1GALzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:55:41 -0400
Date: Fri, 1 Jul 2011 05:55:41 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Moving DT data out of the kernel?
Message-ID: <alpine.DEB.2.00.1107010534260.27025@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Linus,

Recently we've been discussing Device Tree and other forms of kernel 
static data.  Some of us were curious to know if you eventually planned to 
remove files like the ones in arch/powerpc/boot/dts/ from the mainline 
kernel source tree, or keep them in.

Do you have any preferences or plans here?


regards,

- Paul
