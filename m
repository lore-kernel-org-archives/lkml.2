Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1GDP3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:29:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59365 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab1GDP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:29:48 -0400
X-Sasl-enc: PMfgn0TF+LX+i7RCkG7amFFMqZk561s71YUmM8Z0nAD+ 1309793386
Date: Mon, 4 Jul 2011 08:28:57 -0700
From: Greg KH <greg@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
Message-ID: <20110704152857.GA17305@kroah.com>
References: <1308434431.1050.5.camel@mop>
 <20110701211449.GB19805@kroah.com>
 <87k4bysky2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4bysky2.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 02:26:21PM +0930, Rusty Russell wrote:
> On Fri, 1 Jul 2011 14:14:49 -0700, Greg KH <greg@kroah.com> wrote:
> > On Sun, Jun 19, 2011 at 12:00:29AM +0200, Kay Sievers wrote:
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
> > > 
> > > Userspace wants to manage module parameters with udev rules.
> > > This currently only works for loaded modules, but not for
> > > built-in ones.
> > > 
> > > To allow access to the built-in modules we need to
> > > re-trigger all module load events that happened before any
> > > userspace was running. We already do the same thing for all
> > > devices, subsystems(buses) and drivers.
> > > 
> > > This adds the currently missing /sys/module/<name>/uevent files
> > > to all module entries.
> > > 
> > > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Rusty, are you going to take this in your tree?
> 
> Yep, done.

Wonderful, thanks.
