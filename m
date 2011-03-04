Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1CDSpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:45:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47264 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1CDSpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:45:07 -0500
Date: Fri, 4 Mar 2011 10:43:24 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Message-ID: <20110304184324.GQ372@outflux.net>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299255084-4390-1-git-send-email-segoon@openwall.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:11:24PM +0300, Vasiliy Kulikov wrote:
> If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> root) may not read/write arbitrary kernel memory.  In spite of it,
> hibernation allows anyone with an access to either /dev/snapshot or
> /sys/power/ make the full snapshot of the system.  This snapshot may be
> freely changed and uploaded back.

Ah, yes please. I'd like to try to have ways to close all the
"intentional" arbitrary memory writing interfaces. Hooking it to
modules_disable seems as good as any other toggle. Still waiting to hear
anything on this: http://article.gmane.org/gmane.linux.acpi.devel/49471

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
