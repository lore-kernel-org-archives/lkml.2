Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2EBWvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:51:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33213 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2EBWvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:51:19 -0400
Date: Wed, 2 May 2012 15:51:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Message-ID: <20120502225115.GA3535@kroah.com>
References: <201205021538.45056.hartleys@visionengravers.com>
 <20120502224510.GA19693@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502224510.GA19693@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:45:14PM +0100, Mark Brown wrote:
> On Wed, May 02, 2012 at 03:38:44PM -0700, H Hartley Sweeten wrote:
> > Fix the section mismatch be renaming the struct platform_driver
> > variable.
> 
> I'm pretty sure I sent a version of this patch sometime last week :/

So did I, but I can't seem to find it anywhere.  Did I not apply it?

odd.
