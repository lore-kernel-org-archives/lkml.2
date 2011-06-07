Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1FGUzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:55:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34301 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1FGUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:55:19 -0400
Date: Tue, 7 Jun 2011 21:55:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Subject: Re: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Message-ID: <20110607205507.GA1386@srcf.ucam.org>
References: <1307470562-15633-1-git-send-email-mjg@redhat.com>
 <1307470562-15633-4-git-send-email-mjg@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
 <20110607202517.GA732@srcf.ucam.org>
 <987664A83D2D224EAE907B061CE93D5301E70D8F43@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E70D8F43@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:52:32PM -0700, Luck, Tony wrote:

> It depends on your level of paranoia - and on what problems
> you think might occur. In an ideal world all the back-ends
> would work - and we'd just use one until it filled up, and
> then move to the next.  in the real world one of the back-ends
> might just randomly hang the system - converting a crashing
> system into a hung system (which many people consider a more
> severe problem). Giving a user an opt-out method for a back-end
> looks good in that scenario.

Yeah. I guess the question then is whether the mediation should be in 
pstore or at the platform backend level. strcmp in pstore_register seems 
somehow fragile for this, but I guess it'd work?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
