Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0EGXQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:16:23 -0400
Received: from kroah.org ([198.145.64.141]:44259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab0EGXQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:16:22 -0400
Date: Fri, 7 May 2010 16:12:02 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Hank Janssen <hjanssen@microsoft.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>
Subject: Re: RFC - Cleaned up hypervisor layer
Message-ID: <20100507231202.GA13771@kroah.com>
References: <4BE49778.6060800@zytor.com>
 <20100507230210.GB24877@kroah.com>
 <4BE49D76.5000001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE49D76.5000001@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 04:08:38PM -0700, H. Peter Anvin wrote:
> On 05/07/2010 04:02 PM, Greg KH wrote:
> > On Fri, May 07, 2010 at 03:43:04PM -0700, H. Peter Anvin wrote:
> >> This patch implements a cleaned up hypervisor layer, plus cleans up some
> >> of the aspects of both Hank's MS-HyperV patch and the existing VMware
> >> driver.  In particular, the MS-HyperV information is private
> >> information, per system, not per CPU, and can thus simply be stored in
> >> an ordinary global variable.  This also turns the hypervisor detection
> >> into an information structure instead of just an identifier.
> > 
> > This looks great to me, thanks for doing this work.
> > 
> > As this is a diff on top of my previous patch, do you want me to merge
> > it in with it and resend it, or will you?
> > 
> 
> I was planning to put this on top of your patch as a second commit, just
> to preserve history and authorship.

Wonderful.

Ah, I just realized that we cut-and-pasted the GPL lines from the vmware
file, I don't want the "v2 or later" marking on the new file KY added.
Want me to send an add-on patch to fix that up?

thanks,

greg k-h
