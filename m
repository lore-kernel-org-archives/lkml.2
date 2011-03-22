Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1CVIfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:35:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1CVIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:34:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
Date: Tue, 22 Mar 2011 09:34:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220934.50435.arnd@arndb.de>
X-Provags-ID: V02:K0:D1lKxe+wWSW1+g7RPwQ8GvRiNbJh5B/DNfC15zM8jh0
 FOgMrR9/kUUtGAP2VIaUzYYw2+XncIKZ2xyr08G35/wxxptTBx
 cBTzGrGPNc3Pq19ukNlL7xOj3l9pewvLcgGfSCnKS/WfXDNheD
 z2Zavxl6rq7+tHY79BQVAM9FTwNjySkzkz1d7hW0e5LCghTZtS
 WqGB5acw/nZ9OKWTSYdQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, Stephen Boyd wrote:
> Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
> introduced a generic sizes.h. Use that instead of the ARM specific
> version.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de
