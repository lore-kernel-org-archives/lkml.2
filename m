Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab0DLFmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 01:42:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41126 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266Ab0DLFmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 01:42:12 -0400
Date: Mon, 12 Apr 2010 07:41:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       stable@kernel.org
Subject: Re: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX
	block_size_bytes"
Message-ID: <20100412054159.GA1301@ucw.cz>
References: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com> <20100408153745.GA4213@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408153745.GA4213@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-04-08 23:41:24, Am?rico Wang wrote:
> On Thu, Apr 08, 2010 at 05:10:06PM +0200, Heiko Carstens wrote:
> >From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> >Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
> >to HEX block_size_bytes" since it changes the user space visible sysfs interface
> >/sys/devices/system/memory/block_size_bytes.
> >The change breaks existing user space applications which rely on the fact that
> >the output does not contain the "0x" prefix.
> >
> 
> Odd.
> 
> Which application relies on this? Isn't the application which should
> be fixed?? It should use something like strtoul() which doesn't
> rely on '0x' prefix.

'no regressions'?!

You should not randomly change kernel api, then blame it on applications.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
