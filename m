Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab2J3Tkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:40:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2J3Tkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:40:49 -0400
Date: Tue, 30 Oct 2012 12:40:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Behan Webster <behanw@converseincode.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Helper macros used for replacing the use of VLAIS
Message-ID: <20121030194045.GA14892@kroah.com>
References: <1351621520-17768-1-git-send-email-behanw@converseincode.com>
 <1351621520-17768-2-git-send-email-behanw@converseincode.com>
 <20121030192021.GA1979@kroah.com>
 <50902BFC.4090309@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50902BFC.4090309@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 03:35:24PM -0400, Behan Webster wrote:
> On 12-10-30 03:20 PM, Greg KH wrote:
> >On Tue, Oct 30, 2012 at 02:25:19PM -0400, Behan Webster wrote:
> >>The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> >>precludes the use of compilers which don't implement VLAIS (for instance the
> >>Clang compiler). This new header file contains macros which can be used to
> >>calculate the size and offset of variables in an allocated buffer of memory
> >>taking into account alignment issues.
> >>
> >>Signed-off-by: Behan Webster <behanw@converseincode.com>
> >>---
> >>  include/linux/valign.h |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 87 insertions(+)
> >>  create mode 100644 include/linux/valign.h
> >You sent the same patch here, to two different trees (usb and
> >networking).  That's not good, what happens if they both apply them?
> Good point. My mistake.
> 
> People in both subsystems needed to see the patch which is why I sent them.
> 
> What would have been a better approach? And how can I fix this?

Send all 3 as a single series, to everyone and ask the different
maintainers to work together to figure out who is going to apply what.

Yeah, it's tough, but things like this are pretty rare, so they don't
come up often.

greg k-h
