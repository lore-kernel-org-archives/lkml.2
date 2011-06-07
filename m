Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1FGP6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:58:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57580 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1FGP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:58:43 -0400
Date: Tue, 7 Jun 2011 16:58:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Message-ID: <20110607155829.GA25609@srcf.ucam.org>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-3-git-send-email-mjg@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C17497E04@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17497E04@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 11:47:38AM -0400, Seiji Aguchi wrote:
> Hi,
> 
> Recently, I have suggested similar patches.
> Does your patch satisfy my purpose?

I think so. I've been testing it without problems on one machine and I'm 
about to try it on a different vendor. It seemed easier to reuse the 
efivars infrastructure than writing another implementation, and the 
efivars code has at least been tested enough for boot configuration to 
work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
