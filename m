Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1DFXXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:23:33 -0400
Received: from mail.erfurth.eu ([89.107.64.155]:54055 "EHLO mail.erfurth.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab1DFXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:23:32 -0400
X-Greylist: delayed 1989 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 19:23:32 EDT
Message-ID: <4D9CEE24.1080501@erfurth.eu>
Date: Thu, 07 Apr 2011 00:50:12 +0200
From: Nico Erfurth <ne@erfurth.eu>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-arm-kernel@lists.infradead.org, Eric Cooper <ecc@cmu.edu>,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH 0/2] ARM: Unify setup for Marvell SheevaPlugs and Seagate
 DockStars
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler wrote:

> The first patch merges the setup for Seagate DockStars into the setup
> for Marvell SheevaPlugs and the second one removes the machine type for
> DockStars at all.

That looks fine so far.

> Removing the machine type for DockStar shouldn't be a big problem. Support
> for them is already broken in mainline U-Boot since 2 versions, so changing the
> stuff there is already needed and it shouldn't be a problem to use the same
> machine type as used for SheevaPlugs there.

This sounds like very bad reasoning to me. The Dockstar has a machine-id
assigned, if the bootloader is broken, people should either use a
working version, or fix the current one.

Also, using the memory-size to differ between these two machines sounds
like something thats doomed to fail in the future.

Nico
