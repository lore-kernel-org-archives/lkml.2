Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab2EDA2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:28:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50131 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2EDA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:28:34 -0400
Date: Fri, 4 May 2012 01:28:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: strange commits in the drivers-x86 tree
Message-ID: <20120504002830.GA2283@srcf.ucam.org>
References: <20120504101439.edb8133fe986fc4cca94b969@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504101439.edb8133fe986fc4cca94b969@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:14:39AM +1000, Stephen Rothwell wrote:
> Hi Matthew,
> 
> I have no idea what you have done to your tree, but it now contains scsi,
> nfs and arm commits (at least) that don't appear to be at all relevant to
> x86 drivers ... it looks like you may have rebased part of Linus' tree
> onto yours.
> 
> I will use the drivers-x86 tree from next-20120503 for today.

Well that's somewhat bizarre - I did a rebase onto master, git am on a 
maildir, then a rebase -i to drop a conflicting commit. I think we're 
equally confused here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
