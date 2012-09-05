Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2IEPrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:47:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54476 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:47:45 -0400
Date: Wed, 5 Sep 2012 10:46:44 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ashley Lai <adlai@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com
Subject: Re: [PATCH V3 1/3] drivers/char/tpm: Add new device driver to
 support IBM vTPM
Message-ID: <20120905154644.GA14925@linux.vnet.ibm.com>
References: <1344987282.4430.26.camel@footlong>
 <1345670263.25124.7.camel@footlong>
 <20120822214217.GB13519@linux.vnet.ibm.com>
 <1346816407.2257.37.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346816407.2257.37.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090515-5518-0000-0000-0000076292AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:40:07PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2012-08-22 at 16:42 -0500, Kent Yoder wrote:
> > On Wed, Aug 22, 2012 at 04:17:43PM -0500, Ashley Lai wrote:
> > > This patch adds a new device driver to support IBM virtual TPM
> > > (vTPM) for PPC64.  IBM vTPM is supported through the adjunct
> > > partition with firmware release 740 or higher.  With vTPM
> > > support, each lpar is able to have its own vTPM without the
> > > physical TPM hardware.
> > > 
> > > This driver provides TPM functionalities by communicating with
> > > the vTPM adjunct partition through Hypervisor calls (Hcalls)
> > > and Command/Response Queue (CRQ) commands.
> > 
> >  Thanks Ashley, I'll include this in my next pull request to James.
> 
> Oh ? I was about to put it in the powerpc tree ... But yeah, I notice
> there's a change to tpm.h so it probably should be at least acked by the
> TPM folks. As for the subsequent patches, they are powerpc specific so I
> can add them, I don't think there's a strict dependency, is there ?

  James did accept my pull request, so these are already in
security-next...

Kent

