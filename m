Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1L0VVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:21:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1L0VVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:21:30 -0500
Date: Tue, 27 Dec 2011 22:21:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] ACPI: Do cpufreq clamping for throttling per package instead of per CPU
Message-ID: <20111227212126.GF11715@one.firstfloor.org>
References: <1324967687-10559-1-git-send-email-andi@firstfloor.org> <1324967687-10559-5-git-send-email-andi@firstfloor.org> <20111227164323.GA23245@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227164323.GA23245@srcf.ucam.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 04:43:24PM +0000, Matthew Garrett wrote:
> On Mon, Dec 26, 2011 at 10:34:47PM -0800, Andi Kleen wrote:
> 
> > +	if (reduction_pctg(policy->cpu))
> > +		printk("cpufreq notifier %ld\n", event);
> > +
> 
> Needed?

No, i'll drop it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
