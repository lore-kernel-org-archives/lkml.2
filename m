Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0EGXCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:02:18 -0400
Received: from kroah.org ([198.145.64.141]:47545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0EGXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:02:17 -0400
Date: Fri, 7 May 2010 16:02:10 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ky Srinivasan <ksrinivasan@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Hank Janssen <hjanssen@microsoft.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>
Subject: Re: RFC - Cleaned up hypervisor layer
Message-ID: <20100507230210.GB24877@kroah.com>
References: <4BE49778.6060800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE49778.6060800@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 03:43:04PM -0700, H. Peter Anvin wrote:
> This patch implements a cleaned up hypervisor layer, plus cleans up some
> of the aspects of both Hank's MS-HyperV patch and the existing VMware
> driver.  In particular, the MS-HyperV information is private
> information, per system, not per CPU, and can thus simply be stored in
> an ordinary global variable.  This also turns the hypervisor detection
> into an information structure instead of just an identifier.

This looks great to me, thanks for doing this work.

As this is a diff on top of my previous patch, do you want me to merge
it in with it and resend it, or will you?

thanks,

greg k-h
