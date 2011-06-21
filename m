Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1FUNXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:23:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39075 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1FUNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:23:29 -0400
Date: Tue, 21 Jun 2011 14:23:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] ACPI, APEI, GHES, Prevent GHES to be built as
 module
Message-ID: <20110621132317.GC4902@srcf.ucam.org>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
 <1308640587-24502-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640587-24502-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than my proviso in 4/4, this set looks good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
