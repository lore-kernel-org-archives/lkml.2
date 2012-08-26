Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab2HZCbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:31:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2HZCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:30:19 -0400
Date: Sat, 25 Aug 2012 19:30:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [ 40/46] KVM: PIC: call ack notifiers for irqs that are dropped
 form irr
Message-ID: <20120826023014.GA6033@kroah.com>
References: <20120820035832.274275502@linuxfoundation.org>
 <20120820035837.834733550@linuxfoundation.org>
 <1345680175.15245.15.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345680175.15245.15.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:02:55AM +0100, Ben Hutchings wrote:
> On Sun, 2012-08-19 at 20:59 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Gleb Natapov <gleb@redhat.com>
> > 
> > (cherry picked from commit aea218f3cbbcaac249b6b2c98930a00d6d931f1e)
> > 
> > After commit 242ec97c358256 PIT interrupts are no longer delivered after
> > PIC reset. It happens because PIT injects interrupt only if previous one
> > was acked, but since on PIC reset it is dropped from irr it will never
> > be delivered and hence acknowledged. Fix that by calling ack notifier on
> > PIC reset.
> [...]
> 
> Based on the commit blamed for the regression, I think this is needed
> for 3.4 as well.

That's up to Avi and Marcelo, as I do not apply any KVM patches to any
stable tree unless they say so (as they have asked in the past.)

Avi and Marcelo?

greg k-h
