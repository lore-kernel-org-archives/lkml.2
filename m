Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1LFRlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:41:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37710 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LFRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:41:08 -0500
Date: Tue, 6 Dec 2011 17:41:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/5] drivers: power: Rename bq20z75 to sbs-battery
Message-ID: <20111206174100.GA15449@srcf.ucam.org>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:58:03PM -0800, Rhyland Klein wrote:

> +config BATTERY_SBS
> +        tristate "SBS Compliant gas gauge"

This could potentially be confusing with the ACPI SBS code - I guess the 
long term ideal would be to merge them?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
