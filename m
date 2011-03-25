Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1CYWXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:23:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65358 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:23:52 -0400
Date: Fri, 25 Mar 2011 22:23:46 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, vapier@gentoo.org
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325222346.GS3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
 <201103252112.22520.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103252112.22520.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Mar 25, 2011 at 09:12:22PM +0100, Arnd Bergmann wrote:
> On Thursday 24 March 2011 16:21:08 Jamie Iles wrote:
> > OTP memory is typically found in some embedded devices and can be
> > used for storing boot code, cryptographic keys and other persistent
> > information onchip.  This patch adds a generic layer that devices can
> > register OTP with and allows access through a set of character
> > device nodes.
> 
> Looks very nice overall, but I have a few minor comments.

Thanks for taking the time to look at this.  I think I've addressed all 
of your comments in the v3 series apart from defining OTP (which really 
does need to be done so I'll make sure I do that in v4) and the sysfs 
bus/class stuff.  I understand that the intention is for a bus to 
actually represent a subsystem so that does make sense to me (I think!).

Jamie
