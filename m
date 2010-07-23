Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab0GWRvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:51:09 -0400
Received: from eazy.amigager.de ([213.239.192.238]:51310 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0GWRvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:51:05 -0400
Date: Fri, 23 Jul 2010 19:50:56 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16207] Suspend and VT switch hangs since 2.6.34
Message-ID: <20100723175056.GA30411@x61.home>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
 <PRbv8sgxY6G.A.j1F.aVYSMB@chimera>
 <20100723103336.539a3d61@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723103336.539a3d61@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:33:36 -0700, Jesse Barnes wrote:

[...]

> I think this may actually be an X server bug.  2.6.34 introduced some

Hi,

that seems to be not a kernel issue indeed, as at some point I never
got this hang again. However, I upgraded to new versions of Mesa, DRM,
and also new bugfix releases of the Xserver (those in Debian unstable).

Regards,
Tino
