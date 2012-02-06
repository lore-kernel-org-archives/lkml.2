Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2BFSBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:01:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2BFSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:01:05 -0500
Date: Mon, 6 Feb 2012 19:01:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/5] ACPI: EC: Add a limited number of repeats after false EC interrupts
Message-ID: <20120206180104.GO11715@one.firstfloor.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org> <1328545032-21373-4-git-send-email-andi@firstfloor.org> <20120206162740.GA32061@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206162740.GA32061@srcf.ucam.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Our EC code is, at this point, a layer of hacks piled on top of other 
> hacks. We have various patches that fix some machines and break others 
> and a lack of a detailed description of what the driver actually does 
> and where it deviates from the specification (and why).

The moving to an interrupt thread will enable a lot of cleanups
in fact. A lot of the existing code could be simplified now that
you can sleep. A lot of the nasty code was simply a workaround
for that.

I don't have plans to work on this however, since my laptop
works now (sorry). But I believe the patchkit is a good base
for further cleanups.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
