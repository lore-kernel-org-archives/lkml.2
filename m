Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1CJIY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:24:29 -0500
Received: from dspnet.fr ([188.165.44.67]:51262 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1CJIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:24:27 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 03:24:27 EST
Date: Thu, 10 Mar 2011 09:14:07 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: Kernelspace firmware loaders (was: linux-next: manual merge of
 the staging tree with the v4l-dvb tree)
Message-ID: <20110310081407.GA4083@dspnet.fr>
References: <20110304163905.ed6dd630.sfr@canb.auug.org.au>
 <20110307161658.GA9088@kroah.com>
 <AANLkTi=Yavz4=KYNgsR02yTmBU_+BigC9qCSdX4SrTF2@mail.gmail.com>
 <201103092331.00774.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103092331.00774.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:30:59PM +0100, Laurent Pinchart wrote:
> Now, if a vendor provided a firmware in the form of a Java bytecode file, 
> requiring the kernel driver to implement a JVM to load the firmware into the 
> device, would you accept it ?

You extract the data in userspace, turn it into something passive in a
format you define, and implement the actual loader in C in the kernel.
It would not be the first or last time the actual data is extracted
from a vendor-provided package.

  OG.
