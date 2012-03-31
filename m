Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab2CaSDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:03:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34115 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2CaSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:03:22 -0400
Date: Sat, 31 Mar 2012 11:03:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wang YanQing <udknight@gmail.com>
Subject: Re: [ 086/149] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120331180317.GA10792@kroah.com>
References: <20120330194853.145065448@linuxfoundation.org>
 <4F76260C.7080005@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F76260C.7080005@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 09:30:52PM +0000, Florian Tobias Schandinat wrote:
> Hi Greg,
> 
> On 03/30/2012 07:49 PM, Greg KH wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> the same as for 3.3: This patch would require exporting
> 'pcibios_enabled' to not break building uvesafb as a module. As Alan did
> not agree with this approach it is not suitable for stable as is.

Oops, sorry about that, now removed, thanks for letting me know.

greg k-h
