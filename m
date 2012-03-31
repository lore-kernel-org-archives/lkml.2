Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2CaSEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:04:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53439 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2CaSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:03:30 -0400
Date: Sat, 31 Mar 2012 11:03:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wang YanQing <udknight@gmail.com>
Subject: Re: [ 062/108] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120331180327.GB10792@kroah.com>
References: <20120330195731.038243184@linuxfoundation.org>
 <4F762688.7060706@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F762688.7060706@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 09:32:56PM +0000, Florian Tobias Schandinat wrote:
> Hi Greg,
> 
> On 03/30/2012 07:58 PM, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> the same as for 3.3: This patch would require exporting
> 'pcibios_enabled' to not break building uvesafb as a module. As Alan did
> not agree with this approach it is not suitable for stable as is.

Now removed, thanks.

greg k-h
