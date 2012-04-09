Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2DIQsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:48:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52855 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DIQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:48:05 -0400
Date: Mon, 9 Apr 2012 09:47:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: sudhakar <sudhakar@fb.com>, linux-serial@vger.kernel.org,
        alan@linux.intel.com, dan.j.williams@intel.com, nhan.h.mai@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]  8250_pci: Replace commits 448ac154 and e86ff4a
Message-ID: <20120409164759.GA8800@kroah.com>
References: <4F7B52D8.101@fb.com>
 <20120403215832.0520f93d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403215832.0520f93d@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:58:32PM +0100, Alan Cox wrote:
> On Tue, 3 Apr 2012 12:43:20 -0700
> sudhakar <sudhakar@fb.com> wrote:
> 
> > 
> > From: Sudhakar Mamillapalli <sudhakar@fb.com>
> > 
> > 
> > The following commits don't completely fix the KT serial missing
> > interrupt problems.  So they have been replaced instead by
> > enabling serial backup timer.  The iir-once + msi tried approach tried
> > to enforce one read of the iir per THRE event, but its defeated by any
> > other event occurring at the wrong time, particularly MSR events.
> > 
> > 448ac15 serial/8250_pci: setup-quirk workaround for the kt serial controller
> > e86ff4a serial/8250_pci: init-quirk msi support for kt serial controller
> 
> These are already in tree. If you are reversing them and adding a
> different fix then please post the series as
> 
> - two revert patches exactly reverting the two commits
> - a follow on patch or two adding the replacement
> 
> That makes it much easier to review and much more obvious. It also helps
> make testing simpler.

I agree, Sudhakar, can you please redo these 2 patches?

greg k-h
