Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab0DTOyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:54:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34407 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0DTOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:54:37 -0400
Date: Tue, 20 Apr 2010 08:54:29 -0600
From: Alex Chiang <achiang@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lenb@kernel.org, colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100420145429.GB5573@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
	colin.king@canonical.com, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
References: <20100420140314.GA5573@canonical.com>
 <20100420144654.GA6354@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420144654.GA6354@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg59@srcf.ucam.org>:
> On Tue, Apr 20, 2010 at 08:03:14AM -0600, Alex Chiang wrote:
> 
> > In any case, an existing DMI table exists for machines where
> > this defect is a known problem. Lenovo promise to fix their
> > BIOS, but for folks who either won't or can't upgrade their
> > BIOS, allow Linux to workaround the issue.
> 
> While this is certainly the low impact fix for now, I'd prefer
> the patch I sent as a long-term solution in order to avoid
> having to add more machines to the table in future.

Ah, yes, I should have been more clear.

I want to get this patch upstream so we can get it into stable,
so that we can get it into Ubuntu 10.04.

Certainly what I'm proposing is suitable for stable: it's
minimal, specific to a few machines, etc.

For the long term, I support the patch that Matthew sent out
yesterday, and we can perhaps think about removing the quirks
entirely.

Thanks,
/ac

