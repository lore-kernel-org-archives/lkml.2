Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab2DCHWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:22:55 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36072 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2DCHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:22:54 -0400
Date: Tue, 3 Apr 2012 09:22:52 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Hendry <andrew.hendry@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.35-rc4 Graphics performance issue and freeing invalid
 memtype messages on boot.
Message-ID: <20120403072252.GA23945@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402192012.GA32147@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jerome Glisse just helpfully pointed out that I'm running with KMS
disabled (and indeed, CONFIG_DRM_RADEON_KMS is not set).

So we have:
- a CONFIG_DRM_RADEON_KMS which has some pretty strong wording
  discouraging its use (which IIRC is exactly the reason that I decided
to not enable it yet at that time when KMS stuff has been introduced)
- with KMS thus ending up disabled, things failing left and right...

Something's not quite right...


I'm currently doing a (complete, unfortunately) rebuild to retry with
CONFIG_DRM_RADEON_KMS enabled, will report back.

Andreas Mohr
