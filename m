Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2BFR7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:59:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51162 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2BFR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:59:21 -0500
Date: Mon, 6 Feb 2012 18:59:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per package v2
Message-ID: <20120206175918.GN11715@one.firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org> <1328545032-21373-5-git-send-email-andi@firstfloor.org> <20120206163106.GB32061@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206163106.GB32061@srcf.ucam.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 04:31:06PM +0000, Matthew Garrett wrote:
> On Mon, Feb 06, 2012 at 08:17:11AM -0800, Andi Kleen wrote:
> > +#define reduction_pctg(cpu) \
> > +	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
> 
> I don't like using percentages here - we end up with the potential for

The code was using percentages before, i merely moved the accounting
to be per package. I don't disagree with changing them, but it 
should be probably a separate patch.

-Andi
