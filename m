Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2BAO5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:57:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45000 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2BAO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:57:11 -0500
Date: Wed, 1 Feb 2012 14:57:07 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [RFC PATCH 2/2] thermal: Add generic cpu cooling implementation
Message-ID: <20120201145707.GD30184@srcf.ucam.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
 <1323789196-4942-3-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323789196-4942-3-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 08:43:16PM +0530, Amit Daniel Kachhap wrote:
> This patch adds support for generic cpu thermal cooling low level
> implementations using frequency scaling and cpuhotplugg currently.

We've been over this kind of thing in the past. cpu hotplug is a 
relatively expensive operation, so people have previously been 
enthusiastic about using the scheduler to simply avoid running anything 
on CPUs if they're overheating. Has any general consensus been reached 
on this?

I'm also not entirely thrilled at now having two ways to manage the cpu 
through the thermal layer. ACPI already plugs in via the passive trip 
points. If we're going to do this then I'd like to see the ACPI code 
merged in with the generic cpu cooling code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
