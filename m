Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2GFR7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:59:51 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:8919 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2GFR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:59:49 -0400
Message-ID: <4FF72794.7010009@tilera.com>
Date: Fri, 6 Jul 2012 13:59:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/3] arch/tile: provide kernel support for the tilegx
 USB shim
References: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com> <20120706173635.GB2373@kroah.com>
In-Reply-To: <20120706173635.GB2373@kroah.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/2012 1:36 PM, Greg KH wrote:
> On Wed, May 09, 2012 at 12:25:02PM -0400, Chris Metcalf wrote:
>> This change adds support for accessing the USB shim from within the
>> kernel.  Note that this change by itself does not allow the kernel
>> to act as a host or as a device; it merely exposes the built-in on-chip
>> hardware to the kernel.
> What do you mean by this?  This is needed for the other patches, right?
> If so, I'm guessing they are going through the tile tree?  That's fine
> with me.

Correct; this piece just adds the infrastructure that lets you then layer
the standard USB host code on top.  I'm assuming I'll push both the tilegx
USB infrastructure, and the drivers/usb/host stuff, through the tile tree. 
Or, I can push just the low-level stuff through the tile tree and let the
USB host stuff go through the usb tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



