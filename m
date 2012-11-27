Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2K0Xuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:50:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42571 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2K0Xui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:50:38 -0500
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d18:13d2:3217:7b0e]
In-Reply-To: <1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
	<1354058956-7199-2-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 27 Nov 2012 15:50:37 -0800
Message-ID: <CAOesGMgg6oKHWkPaLxR96J0n5AGJqpx0MrTQQv0gW3szLhZ3+A@mail.gmail.com>
Subject: Re: [PATCH V7 2/7] ARM: dt: change .dtb build rules to build in dts directory
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 3:29 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> The current rules have the .dtb files build in a different directory
> from the .dts files. The only reason for this is that it was what
> PowerPC has done historically. This patch changes ARM to use the generic
> dtb rule which builds .dtb files in the same directory as the source .dts.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [swarren: added rm command for old stale .dtb files]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>
