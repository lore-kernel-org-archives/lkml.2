Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1C3Kdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:33:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59597 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1C3Kdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:33:31 -0400
Date: Wed, 30 Mar 2011 11:33:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] gma500: Add Moorestown backlight support
Message-ID: <20110330103324.GA29796@srcf.ucam.org>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
 <20110330090002.5897.78332.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330090002.5897.78332.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:00:05AM +0100, Alan Cox wrote:

> +	/* Percentage 1-100% being valid */
> +	if (level < 1)
> +		level = 1;

I know you're not actually changing anything here, but opregion supports 
requesting brightnesses between 0 and 255 - it'd be easier if we only 
had one level of scaling, rather than having to map that to a percentage 
only for it to be remapped to the hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
