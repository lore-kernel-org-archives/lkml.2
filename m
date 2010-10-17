Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0JQOJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:09:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54509 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab0JQOJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:09:23 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, hpa@zytor.com, devel@lists.fedoraprojet.org
In-Reply-To: <1287313332.1998.172.camel@laptop>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 10:09:20 -0400
Message-ID: <1287324560.3125.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 13:02 +0200, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 01:57 -0400, Mimi Zohar wrote:
> > On Sat, 2010-10-16 at 15:20 -0400, Christoph Hellwig wrote:
> > > Besides the algorithmic problems with ima, why is kernel.org using
> > > IMA to start with?  Except for IBM looking for a reason to jusity why
> > > TPM isn't a completely waster of ressources it's pointless.  And it was
> > > only merged under the premise that it would not affect innocent normal
> > > users.
> > > 
> > 
> > Can we keep this at the design level please? When IMA is enabled, it
> > needs to store information on a per inode basis, yet has to wait to
> > late_initcall() for the TPM, at which point some inodes would have
> > already been created.  
> 
> Being build (CONFIG_IMA=y) is not the same as default enabled. Is there
> a way to build this stuff and not have it enabled?

At one point there was a command line option, similar to
SECURITY_SELINUX_BOOTPARAM, to enable/disable IMA.  Based on review
here, it was removed.

Mimi

