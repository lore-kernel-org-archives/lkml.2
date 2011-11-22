Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1KVTXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:23:19 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53490 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071Ab1KVTXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:23:15 -0500
X-Sasl-enc: 21OJbOiZPX6N3TiqBhTnXV8SYksdmP5XGDU6R6D82YkT 1321989794
Date: Tue, 22 Nov 2011 11:23:00 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, siglesia@cern.ch, manohar.vanga@cern.ch
Subject: Re: [RGC PATCH 0/2] split file2alias using elf sections
Message-ID: <20111122192300.GA5052@kroah.com>
References: <cover.1320408578.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1320408578.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 01:23:00PM +0100, Alessandro Rubini wrote:
> When adding a new bus type with autoloading of modules, people should
> always change the global scripts/mod/file2alias.c source file, whereas
> most of the new code is just new files and individual Makefile/Kconfig
> lines.
> 
> The first patch turns all the "normal" alias generation in a
> table-driven loop. The second patch moves a few alias types out of the
> main file2alias.c source, as a demonstration that the thing works.
> 
> I didn't move all bus/alias types out of the main file, as it's a huge
> work. But if the approach is going to be accepted I can do that (or
> happily leave the task to who volunteers).

Yes!!!!

I've been wanting this for years, and so have others (Linus, Andrew,
etc.)

I'll gladly take this through my driver-core tree, as it can handle
cross-bus issues like this.

Do you feel this series is good enough to accept, or do you want to
respin it again?

thanks,

greg k-h
