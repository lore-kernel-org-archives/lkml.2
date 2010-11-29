Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0K2PUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:20:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56274 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0K2PUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:20:08 -0500
Date: Mon, 29 Nov 2010 15:19:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@suse.com>
Subject: Re: [REGRESSION] Suspend fails because of TPM modules
Message-ID: <20101129151953.GA9501@srcf.ucam.org>
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:15:21PM +0100, Jiri Kosina wrote:

> I just found out, that if I modprobe tpm_tis module with
> 
> 	itpm=1
> 
> parameter, the problem doesn't happen any more and suspend works fine.
> 
> This definitely wasn't needed on older kernels though, so I'd consider 
> that still a regression.
> 
> Also, can't we make the module automatically detect the machines on which 
> to apply the workaround? Let's say, based on DMI?

http://lkml.org/lkml/2010/10/21/456

-- 
Matthew Garrett | mjg59@srcf.ucam.org
