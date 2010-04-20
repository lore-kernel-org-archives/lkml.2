Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0DTROX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:14:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37350 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0DTROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:14:22 -0400
Date: Tue, 20 Apr 2010 18:14:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jerone Young <jerone.young@canonical.com>
Cc: Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
       colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
	Lenovo ThinkPads
Message-ID: <20100420171415.GA9550@srcf.ucam.org>
References: <20100420140314.GA5573@canonical.com> <1271782601.25170.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271782601.25170.105.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:56:41AM -0500, Jerone Young wrote:
> Don't think this patch should go in as Lenovo is issuing a BIOS to
> address this issue. On these Thinkpads listed and more. Seems to add
> uneeded quirks in my opinion.
> 
> Though some over all patch may be good for all machines. As Windows
> seems to be setting this bit on it's own.

It's a perfectly safe workaround that's limited to a well-bounded set of 
machines and fixes a pretty serious problem with them. While I'd prefer 
my approach and then a removal of the existing quirk entries, Alex's 
patch makes more sense for stable. The BIOS update is as yet unreleased, 
requires either Windows or an optical drive (which some of these 
machines don't have) and is a far from discoverable solution to the 
issue.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
