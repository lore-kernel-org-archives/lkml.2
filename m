Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2LRPI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:08:56 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:40238 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2LRPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:08:55 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 10:08:55 EST
Message-ID: <50D08547.8040405@free-electrons.com>
Date: Tue, 18 Dec 2012 16:01:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: torvalds@linux-foundation.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8
References: <20121218065502.GA12865@quad.lixom.net>
In-Reply-To: <20121218065502.GA12865@quad.lixom.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Le 18/12/2012 07:55, Olof Johansson a écrit :
> Maxime Ripard (1):
>       ARM: sunxi: Change device tree naming scheme for sunxi

There's something odd about this one (commit 68136b10). The patch that
you seem to have applied differs from the one I sent. The DTs files
appears to have not been renamed, while in the patch I sent
(http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137105.html),
it's the case.

Do you know what happened here? What can we do to fix that?

Maxime
-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
