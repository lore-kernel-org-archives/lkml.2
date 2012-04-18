Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2DRS3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:29:53 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49939 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab2DRS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:29:51 -0400
From: Kevin Hilman <khilman@ti.com>
To: jean.pihet@newoldbits.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH v2 0/9] PM: Create the AVS class of drivers
Organization: Texas Instruments, Inc.
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
Date: Wed, 18 Apr 2012 11:29:49 -0700
In-Reply-To: <1332173578-27422-1-git-send-email-j-pihet@ti.com> (jean pihet's
	message of "Mon, 19 Mar 2012 17:12:49 +0100")
Message-ID: <87aa28ki5e.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jean.pihet@newoldbits.com writes:

> From: Jean Pihet <j-pihet@ti.com>
>
> AVS is a power management technique which controls the operating

nit: you don't define AVS anywhere here, so those not familiar with the
technique will probably be lost in acronyms.  I suggest you add what it
means after the first use: e.g.  "AVS (Adaptive Voltage Scaling) is
a...."

Kevin
