Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1BHWXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:23:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35885 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab1BHWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:23:37 -0500
Date: Tue, 8 Feb 2011 14:23:04 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, mtk.manpages@gmail.com
Subject: Re: [PATCH v2 1/2] Export linux/syslog.h
Message-ID: <20110208222304.GO1457@outflux.net>
References: <1297203320.1748.14.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297203320.1748.14.camel@t41.thuisdomein>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks fine to me.

On Tue, Feb 08, 2011 at 11:15:08PM +0100, Paul Bolle wrote:
> Userspace programs (like util-linux' dmesg) still use magic numbers for
> the klogctl function (glibc's interface to the syslog system call).
> Exporting linux/syslog.h makes the more descriptive named constants
> available as a single reference for these values.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Signed-off-by: Kees Cook <kees.cook@canonical.com>

-Kees

-- 
Kees Cook
Ubuntu Security Team
