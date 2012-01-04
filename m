Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2ADPTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:19:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2ADPTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:19:44 -0500
Date: Wed, 4 Jan 2012 07:18:25 -0800
From: Greg KH <gregkh@suse.de>
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Moore, Eric" <Eric.Moore@lsi.com>
Subject: Re: [50/75] mpt2sas crashes on shutdown
Message-ID: <20120104151825.GA29043@suse.de>
References: <20120103223332.GA4112@kroah.com>
 <20120103223325.206012007@clark.kroah.org>
 <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A60481D5AAEC@inbmail02.lsi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Jan 04, 2012 at 02:23:27PM +0530, Nandigama, Nagalakshmi wrote:
> Greg,
> As a fix to this issue, I posted the patch "[PATCH] mpt2sas: Remove
> msix_table_backup which is required only for preproduction boards".
> The patch in this mail will not address the complete issue. 
> 
> Please revert back this patch and add the patch "[PATCH] mpt2sas:
> Remove msix_table_backup which is required only for preproduction
> boards" to the stable kernels 3.0 and 3.1.

As I stated in the thread of that patch, I can't accept that patch
as-is.  Please resend it according to the instructions I gave you, which
for some reason, you ignored.  Because you didn't respond, I took
David's patch, which did follow the stable kernel rules.  So I'll keep
this patch in, until I get something that properly supersedes it.

greg k-h
