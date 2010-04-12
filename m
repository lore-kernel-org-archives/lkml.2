Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0DLGTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:19:09 -0400
Received: from kroah.org ([198.145.64.141]:34863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0DLGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:19:08 -0400
Date: Sun, 11 Apr 2010 23:16:05 -0700
From: Greg KH <greg@kroah.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.2 does not boot on Atom?
Message-ID: <20100412061604.GB31112@kroah.com>
References: <20100406205509.GA12034@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406205509.GA12034@linux-m68k.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:55:09PM +0200, Richard Zidlicky wrote:
> Hi,
> 
> I have been compiling my own kernels since ages and switched from 2.6.32.8 to 
> 2.6.33.2 now.
> Same procedure like allways - copied .config to new buildtree, make menuconfig
> (almost nothing changed in config), installed the new kernel on 2 machines.

Oops, that's the problem, you need to do 'make oldconfig' to ensure you
didn't miss anything, and to adjust any new defaults.

Have you tried that?

greg k-h
