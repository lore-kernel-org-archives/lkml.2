Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab1JaNoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:44:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:56351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab1JaNoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:44:54 -0400
Subject: Re: [RFC][PATCH 1/2] uio: allow drivers to override the pgprot for mmap
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111029063809.GC2280@kroah.com>
Date: Mon, 31 Oct 2011 08:44:40 -0500
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A4AFF4A3-0F5F-430C-BD34-CC043C0644AB@kernel.crashing.org>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org> <20111028214812.GD23092@local> <20111029063809.GC2280@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29, 2011, at 1:38 AM, Greg KH wrote:

> On Fri, Oct 28, 2011 at 11:48:12PM +0200, Hans J. Koch wrote:
>> On Fri, Oct 28, 2011 at 10:50:29AM -0500, Kumar Gala wrote:
>>> For some devices, the default behavior of pgprot_noncached() is not
>>> appropriate for all of its mappable regions. This provides a means for
>>> the kernel side of the UIO driver to override the flags without having
>>> to implement its own full mmap callback.
>> 
>> Thanks for also providing an example driver showing the use of this.
>> You should also post this driver in a mainline-ready version, I'm a bit
>> uncomfortable with adding a new function pointer without having any users.
> 
> I'm more than "uncomfortable", I'll refuse to take any such patch unless
> there is a in-kernel user, otherwise it makes no sense to add the
> pointer at all.
> 
> thanks,
> 
> greg k-h

I'm in agreement with this view.  I wanted to post this to make sure the direction we took was ok so when the upstream driver is posted this patch / change isn't a concern.

- k