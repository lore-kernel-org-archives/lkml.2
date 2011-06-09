Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1FIUvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:51:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49256 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046Ab1FIUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:51:31 -0400
X-Sasl-enc: SRUAFfDqSqFV9OuMqeJsyYSwQPkvyNXFfEZUwCUK9hl/ 1307652690
Date: Thu, 9 Jun 2011 13:51:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Vossen <rvossen@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110609205101.GA32526@kroah.com>
References: <20110609165808.8b36f634.sfr@canb.auug.org.au>
 <20110609184143.GB2760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609184143.GB2760@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:41:43AM -0700, Greg KH wrote:
> On Thu, Jun 09, 2011 at 04:58:08PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/brcm80211/brcmfmac/wl_iw.c between commit e1c78de9a462
> > ("staging: brcm80211: fix for 'multiple definition of wl_msg_level' build
> > err") from the staging.current tree and commit 8817f75429a1 ("staging:
> > brcm80211: removed wl_ (vendor specific acronym)") from the staging tree.
> > 
> > I fixed it up (using the latter change) and can carry the fix as
> > necessary.
> 
> Thanks for the fix, it sounds correct.

This should now be resolved.

greg k-h
