Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1GDFeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:34:15 -0400
Received: from ozlabs.org ([203.10.76.45]:56913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1GDFeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:34:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <20110701211449.GB19805@kroah.com>
References: <1308434431.1050.5.camel@mop> <20110701211449.GB19805@kroah.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jul 2011 14:26:21 +0930
Message-ID: <87k4bysky2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 14:14:49 -0700, Greg KH <greg@kroah.com> wrote:
> On Sun, Jun 19, 2011 at 12:00:29AM +0200, Kay Sievers wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
> > 
> > Userspace wants to manage module parameters with udev rules.
> > This currently only works for loaded modules, but not for
> > built-in ones.
> > 
> > To allow access to the built-in modules we need to
> > re-trigger all module load events that happened before any
> > userspace was running. We already do the same thing for all
> > devices, subsystems(buses) and drivers.
> > 
> > This adds the currently missing /sys/module/<name>/uevent files
> > to all module entries.
> > 
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Rusty, are you going to take this in your tree?

Yep, done.

Thanks,
Rusty.

