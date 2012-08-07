Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2HGLiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:38:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59866 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab2HGLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:38:03 -0400
Date: Tue, 7 Aug 2012 12:38:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807113801.GB16861@opensource.wolfsonmicro.com>
References: <20120806155805.GR16861@opensource.wolfsonmicro.com>
 <20120806192209.GA14594@flint.arm.linux.org.uk>
 <20120806195352.GC16199@opensource.wolfsonmicro.com>
 <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
 <20120807112844.GZ16861@opensource.wolfsonmicro.com>
 <20120807113121.GD24257@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807113121.GD24257@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:31:21PM +0100, Russell King wrote:
> On Tue, Aug 07, 2012 at 12:28:44PM +0100, Mark Brown wrote:

> > The changes you're suggesting are extremely invasive for stable
> > especially given that we have a simple, driver local, fix available

> *Rubbish*.

This isn't helpful or constructive...

Which bit of the above are you referring to here?  If it's the having a
fix bit then as pointed out repeatedly now in this and the previous
thread we've got the separete resource tree approach implemented in
stable right now making actual systems run.
