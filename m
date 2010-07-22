Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0GVWL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:11:26 -0400
Received: from mail.perches.com ([173.55.12.10]:2044 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0GVWLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:11:24 -0400
Subject: Re: [PATCH 2/2] Staging: dt3155: Fixed all printk warnings found
 by checkpatch.pl
From: Joe Perches <joe@perches.com>
To: kagen101@gmail.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1279828847.759.4.camel@dermezel>
References: <1279828847.759.4.camel@dermezel>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 15:11:20 -0700
Message-ID: <1279836680.1909.68.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 22:00 +0200, Joe Eloff wrote:
> >From 8f5fff4e75aec2d77575c2ca2dd6a166ac473b18 Mon Sep 17 00:00:00 2001
> From: Joe Eloff <kagen101@gmail.com>
> Date: Thu, 22 Jul 2010 20:42:04 +0200
> Subject: [PATCH 2/2] Staging: dt3155: Fixed all printk warnings found by checkpatch.pl
> 
> Added all KERN_ levels in printk found by checkpatch.pl

The levels you add for KERN_ prefixes seem arbitrary.
I think you should verify them.

