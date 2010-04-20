Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0DTRTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:19:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47611 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0DTRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:19:03 -0400
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
From: Jerone Young <jerone.young@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
       colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <20100420171415.GA9550@srcf.ucam.org>
References: <20100420140314.GA5573@canonical.com>
	 <1271782601.25170.105.camel@laptop>  <20100420171415.GA9550@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 12:18:56 -0500
Message-ID: <1271783936.25170.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 18:14 +0100, Matthew Garrett wrote:
> On Tue, Apr 20, 2010 at 11:56:41AM -0500, Jerone Young wrote:
> > Don't think this patch should go in as Lenovo is issuing a BIOS to
> > address this issue. On these Thinkpads listed and more. Seems to add
> > uneeded quirks in my opinion.
> > 
> > Though some over all patch may be good for all machines. As Windows
> > seems to be setting this bit on it's own.
> 
> It's a perfectly safe workaround that's limited to a well-bounded set of 
> machines and fixes a pretty serious problem with them. While I'd prefer 
> my approach and then a removal of the existing quirk entries, Alex's 
> patch makes more sense for stable. The BIOS update is as yet unreleased, 
> requires either Windows or an optical drive (which some of these 
> machines don't have) and is a far from discoverable solution to the 
> issue.

I could agree, but the only issue is if you go to the thinkpad-acpi or
ibm-acpi mailing list they would probably disagree as there have been
updates to the bios in the past required for proper functionality of
Thinkpads ;-) .. the bios update methods have not changed since then for
Thinkpads.

			Thanks,
				Jerone





