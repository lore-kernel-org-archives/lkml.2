Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0FVQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:38:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FVQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:38:35 -0400
Date: Tue, 22 Jun 2010 17:38:17 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100622163817.GE20668@srcf.ucam.org>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com> <20100617091322.b7d21473.randy.dunlap@oracle.com> <4C1A7D61.8010900@redhat.com> <20100621122145.76ebd7ac.akpm@linux-foundation.org> <20100621194559.GI3217@redhat.com> <20100621130008.d3dc01a8.akpm@linux-foundation.org> <20100622153457.GA5381@redhat.com> <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 04:48:35PM +0100, Alan Cox wrote:
> > +	printk(KERN_CRIT "UNSUPPORTED HARDWARE DEVICE: %s\n", msg);
> > +	WARN_TAINT(1, TAINT_HARDWARE_UNSUPPORTED,
> > +		   "Your hardware is unsupported.  Please do not report "
> > +		   "bugs, panics, oopses, etc., on this hardware.\n");
> 
> And as already pointed out it's not unsupported hardware even in the case
> you described

It's hardware that isn't supported by the vendor. How is it not 
unsupported hardware in that context?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
