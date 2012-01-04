Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2ADXFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:05:06 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48975 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab2ADXFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:05:03 -0500
X-Sasl-enc: jkm9wzOjUJtDKJaMR10mjLygFmDB6XlG/tQfQ5rat79J 1325718302
Date: Wed, 4 Jan 2012 14:52:20 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip
 tree
Message-ID: <20120104225220.GA24583@kroah.com>
References: <20111228155707.f4554d3d6b624189e4216aed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228155707.f4554d3d6b624189e4216aed@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 03:57:07PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> include/linux/cpu.h between commit 2987557f52b9 ("driver-core/cpu: Expose
> hotpluggability to the rest of the kernel") from the tip tree and commit
> 8a25a2fd126c ("cpu: convert 'cpu' and 'machinecheck' sysdev_class to a
> regular subsystem") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary

Looks fine, thanks.

greg k-h
