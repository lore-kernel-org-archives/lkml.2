Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0K2Pch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:32:37 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47493 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0K2Pcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:32:36 -0500
Date: Mon, 29 Nov 2010 15:32:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@suse.com>,
        jmorris@namei.org
Subject: Re: [REGRESSION] Suspend fails because of TPM modules
Message-ID: <20101129153224.GA10173@srcf.ucam.org>
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz> <4CF3C547.6020302@linux.vnet.ibm.com> <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:26:19PM +0100, Jiri Kosina wrote:

> Any ideas why other kernels were OK (.34) and didn't require this quirk on 
> my machine at all?

We previously ignored devices that had an invalid PNP ID in _HID, 
whereas now we still pay attention to them if they have a valid ID in 
_CID.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
