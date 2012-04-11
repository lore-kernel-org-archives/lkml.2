Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453Ab2DKXpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:45:23 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41632 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965146Ab2DKXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:45:18 -0400
Date: Wed, 11 Apr 2012 16:45:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120411234514.GA11085@kroah.com>
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
 <20120409220847.GA13124@kroah.com>
 <4F86094C.1060700@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F86094C.1060700@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:44:28AM +0200, Markus Franke wrote:
> Am 10.04.2012 00:08, schrieb Greg KH:
> 
> > On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke wrote:
> >> This patch adds a 1-wire slave device driver for the DS28E04-100.
> >>
> >> It applies to the current linux kernel git tree.
> > 
> > It's corrupted somehow and doesn't apply at all :(
> > 
> > Care to redo this one, and your 2/2 patch, against the 3.4-rc2 release
> > and resend it, with Evgeniy's acks, so that I can apply it?  Please
> > ensure that your email client doesn't mess it up again (hint, it is
> > adding spaces at the front of the line of some parts of the diff.)
> 
> 
> Used Thunderbird with external editor (vi) now, sent the patches to
> myself and applied successfully. Hope it is in a shape which can be
> accepted now.

They worked fine, thanks for resending them.

greg k-h
