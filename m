Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab1GAVQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:16:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51725 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597Ab1GAVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:16:34 -0400
X-Sasl-enc: dytt+PsXn4PNSh/+6qhm4rvdTjCy0pUcfCLraL4EXqQs 1309554993
Date: Fri, 1 Jul 2011 14:14:49 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
Message-ID: <20110701211449.GB19805@kroah.com>
References: <1308434431.1050.5.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308434431.1050.5.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 12:00:29AM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
> 
> Userspace wants to manage module parameters with udev rules.
> This currently only works for loaded modules, but not for
> built-in ones.
> 
> To allow access to the built-in modules we need to
> re-trigger all module load events that happened before any
> userspace was running. We already do the same thing for all
> devices, subsystems(buses) and drivers.
> 
> This adds the currently missing /sys/module/<name>/uevent files
> to all module entries.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Rusty, are you going to take this in your tree?

