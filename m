Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1G3TCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:02:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54525 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1G3TCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:02:45 -0400
Date: Sat, 30 Jul 2011 12:02:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] input: mouse/hgpk.c needs module.h
Message-ID: <20110730190240.GB5686@core.coreip.homeip.net>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
 <20110729211441.5de62eca.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729211441.5de62eca.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:14:41PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> hgpk.c uses interfaces from linux/module.h, so it should
> include that file.  This fixes build errors.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks Randy.

-- 
Dmitry
