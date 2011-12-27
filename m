Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1L0VlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:41:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50438 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1L0VlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:41:09 -0500
Date: Tue, 27 Dec 2011 21:41:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] ACPI: Do cpufreq clamping for throttling per
 package instead of per CPU
Message-ID: <20111227214105.GA25565@srcf.ucam.org>
References: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
 <1324967687-10559-5-git-send-email-andi@firstfloor.org>
 <20111227164323.GA23245@srcf.ucam.org>
 <20111227212126.GF11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227212126.GF11715@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 10:21:26PM +0100, Andi Kleen wrote:
> On Tue, Dec 27, 2011 at 04:43:24PM +0000, Matthew Garrett wrote:
> > On Mon, Dec 26, 2011 at 10:34:47PM -0800, Andi Kleen wrote:
> > 
> > > +	if (reduction_pctg(policy->cpu))
> > > +		printk("cpufreq notifier %ld\n", event);
> > > +
> > 
> > Needed?
> 
> No, i'll drop it.

Thanks. Also, 3/4 didn't seem to make it to -kernel or -acpi.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
