Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0HRN1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:27:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60829 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0HRN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:27:36 -0400
Date: Wed, 18 Aug 2010 14:27:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 3/8] ideapad: make sure we bind on the correct device
Message-ID: <20100818132722.GA12709@srcf.ucam.org>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282120653-11434-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282120653-11434-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:37:33PM +0800, Ike Panhc wrote:
> By reading from method _STA and _CFG to make sure we bind on the correct
> VPC2004 device.

I know some other drivers check _STA themselves, but it's unnecessary - 
if _STA didn't evaluate appropriately, the bus driver won't create the 
pnp object and there won't be anything for you to bind to in the first 
place.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
