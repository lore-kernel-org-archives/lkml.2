Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2ECSA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:00:58 -0400
Received: from matrixpower.ru ([195.178.208.66]:34824 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360Ab2ECSA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:00:57 -0400
Date: Thu, 3 May 2012 22:00:56 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120503180056.GB13988@ioremap.net>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502202134.GB26628@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:21:34PM -0700, Greg KH (greg@kroah.com) wrote:
> > Well, I just stuck to the way things are done in already existing
> > drivers e.g. drivers/w1/slaves/w1_ds2433.c
> 
> Really?  Ick, where are those files documented?

I'm kinda lost here.

To clarify things a bit - w1 allows to create 'private' sysfs files for
special functionality which exists only in given driver - like
enable/disable checksum and so on. It has to be documented and must
follow common kernel codying standards of course.

-- 
	Evgeniy Polyakov
