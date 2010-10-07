Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0JGTqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:46:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21253 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0JGTqm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 7 Oct 2010 15:46:42 -0400
Date: Thu, 7 Oct 2010 15:44:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v7] Xen PCI + Xen PCI frontend driver.
Message-ID: <20101007194431.GA32442@dumpdata.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
 <4CAAF428020000780001A834@vpn.id2.novell.com>
 <20101006225043.GA20211@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006225043.GA20211@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 06:50:43PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 05, 2010 at 08:47:20AM +0100, Jan Beulich wrote:
> > >>> On 04.10.10 at 20:13, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > This patch set contains the supporting patches and the driver itself for
> > > Xen Paravirtualized (PV) domains to use PCI pass-through devices (the git 
> > > tree
> > > is git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
> > > devel/xen-pcifront-0.7).
> .. snip..
> > Somehow this patch series appears to be incomplete: Neither on
> > xen-devel nor on patchwork I can find patches 6, 11, 18, 19, and 20.
> 
> Shucks! I am not sure what happend, the git-send-email looked to have sent them 
> all.  Let me redo them and resend them with more attention to this.

AHA! I think I know the answer. Those are the patches for which the Author:
is bouncing. Any ideas of what to do except next time just manually respond
and paste in the patches?

