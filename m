Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2EXCNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:13:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43511 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755327Ab2EXCNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:13:30 -0400
Message-ID: <1337825608.4279.4.camel@joe2Laptop>
Subject: Re: Excessive latency for dev_dbg?
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay@vrfy.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 23 May 2012 19:13:28 -0700
In-Reply-To: <20120524021208.GA12557@kroah.com>
References: <Pine.LNX.4.44L0.1205231627140.1248-100000@iolanthe.rowland.org>
	 <1337805903.1747.0.camel@joe2Laptop> <20120524021208.GA12557@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 19:12 -0700, Greg KH wrote:
> On Wed, May 23, 2012 at 01:45:03PM -0700, Joe Perches wrote:
> > cc'ing Kay.
> > > What's going on here?  Did printk suddenly slow down a lot?  Or has the
> > > timer code gone crazy?
> Joe, why ask Kay?  He didn't touch this code until 3.5-rc1, and Alan is
> testing 3.4.

Sorry, my mistake.

