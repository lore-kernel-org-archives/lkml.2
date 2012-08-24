Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2HXAdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:33:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53939 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2HXAdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:33:21 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 23 Aug 2012 17:33:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: Build regressions/improvements in v3.6-rc3
Message-ID: <20120824003315.GA3360@roeck-us.net>
References: <1345754768-4634-1-git-send-email-geert@linux-m68k.org>
 <5036AC23.8020309@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036AC23.8020309@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 03:18:11PM -0700, Randy Dunlap wrote:
> On 08/23/2012 01:46 PM, Geert Uytterhoeven wrote:
> 
> > *** ERRORS ***
> > 
> > 54 regressions:
> 
> 
> >   + drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem':  => 56:6
> >   + drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem':  => 134:6
> 
> Anyone see what causes this?  I looked but failed to see
> the problem.
> 
sh target, maybe ? dump_mem is declared as global function in arch/sh/include/asm/kdebug.h.
Does not seem to be the best name for a global function.

Guenter
