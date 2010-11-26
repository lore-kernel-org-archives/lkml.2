Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0KZVAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:00:11 -0500
Received: from mail.lixom.net ([70.86.134.90]:58970 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0KZVAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:00:09 -0500
Date: Fri, 26 Nov 2010 15:00:08 -0600
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hari Kanigeri <h-kanigeri2@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        akpm@linux-foundation.org, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101126210008.GA27223@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net> <AANLkTimkovvHzgdnGtGpTH1pz8QLi9K0-rcWVHCdMJbu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimkovvHzgdnGtGpTH1pz8QLi9K0-rcWVHCdMJbu@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 12:18:49AM -0700, Grant Likely wrote:
> On Thu, Nov 25, 2010 at 9:59 PM, Olof Johansson <olof@lixom.net> wrote:
> > On Tue, Nov 23, 2010 at 05:38:57PM +0200, Ohad Ben-Cohen wrote:
> >> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> >
> > Not used.
> 
> pr_fmt() is a magic #define that changes the behaviour of the pr_*()
> macros.  See include/linux/kernel.h

D'oh, thanks.


-Olof
