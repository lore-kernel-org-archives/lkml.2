Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2DBQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:28:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2DBQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:28:19 -0400
Date: Mon, 2 Apr 2012 09:23:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Chanho Min <chanho0207@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jong-Sung Kim <neidhard.kim@lge.com>
Subject: Re: [ 033/108] serial: PL011: clear pending interrupts
Message-ID: <20120402162302.GA10138@kroah.com>
References: <20120330195812.GA31833@kroah.com>
 <20120330195726.845212875@linuxfoundation.org>
 <CACRpkda-feATvkKnSb68PDkQrvqNnbsVSG=naxtdW7FHdRUX2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda-feATvkKnSb68PDkQrvqNnbsVSG=naxtdW7FHdRUX2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 01:43:18PM +0200, Linus Walleij wrote:
> On Fri, Mar 30, 2012 at 9:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> Objections: do not add this to the stable series unless the currently
> under-review patch "serial: PL011: move interrupt clearing" is
> also included.
> 
> Together they solve a real problem, but alone this causes a new
> problem.

Ok, sorry about that, now removed from the 3.0, 3.2, and 3.3-stable
trees.

When the other fix makes it into Linus's tree, care to remind me about
this one so I can add it back?

thanks,

greg k-h
