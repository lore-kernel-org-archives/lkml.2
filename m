Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932Ab0EEQ1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:27:38 -0400
Received: from kroah.org ([198.145.64.141]:51190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934888Ab0EEQ1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:27:14 -0400
Date: Wed, 5 May 2010 09:21:01 -0700
From: Greg KH <greg@kroah.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: devel@driverdev.osuosl.org, Joe Perches <joe@perches.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       support@sbei.com, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, support@onestopsystems.com
Subject: Re: [PATCH -next] staging/cxt1e1: Convert bare printks to
 pr_<level>
Message-ID: <20100505162101.GA12809@kroah.com>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
 <20100503110657.00b4e140.randy.dunlap@oracle.com>
 <1272915196.30040.163.camel@Joe-Laptop.home>
 <201005051421.14647.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201005051421.14647.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:21:14PM +0200, Peter Hüwe wrote:
> Am Montag 03 Mai 2010 21:33:16 schrieb Joe Perches:
> > Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > A few line splits for long arguments
> > A couple of embedded function names converted to "%s", __func__
> > Removed some uses of THIS_MODULE->name
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Hi, 
> I applied Joe's patch, but unfortunately it misses out one part of Randy's 
> original patch, i.e. the conversion in line 286 of hwprobe.c.
> 
> Joe: Can you perhaps add this to your patch?

I've already applied Joe's patch, so I'll queue up yours as well.

thanks,

greg k-h
