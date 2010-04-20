Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0DTOrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:47:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59000 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0DTOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:47:03 -0400
Date: Tue, 20 Apr 2010 15:46:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alex Chiang <achiang@canonical.com>, lenb@kernel.org,
       colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
	Lenovo ThinkPads
Message-ID: <20100420144654.GA6354@srcf.ucam.org>
References: <20100420140314.GA5573@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420140314.GA5573@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 08:03:14AM -0600, Alex Chiang wrote:

> In any case, an existing DMI table exists for machines where this
> defect is a known problem. Lenovo promise to fix their BIOS, but
> for folks who either won't or can't upgrade their BIOS, allow
> Linux to workaround the issue.

While this is certainly the low impact fix for now, I'd prefer the patch 
I sent as a long-term solution in order to avoid having to add more 
machines to the table in future.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
