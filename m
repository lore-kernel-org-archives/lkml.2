Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1FPB5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 21:57:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46601 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1FPB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 21:57:49 -0400
Date: Thu, 16 Jun 2011 02:57:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110616015736.GA32533@srcf.ucam.org>
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
 <20110614145246.GA17469@srcf.ucam.org>
 <4DF82CBC.5070400@intel.com>
 <20110615121703.GA8638@srcf.ucam.org>
 <4DF950EB.7050400@intel.com>
 <20110616013812.GA32494@srcf.ucam.org>
 <4DF962AE.60204@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF962AE.60204@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:55:58AM +0800, Huang Ying wrote:
> On 06/16/2011 09:38 AM, Matthew Garrett wrote:
> > I think we probably need to make the HEST decision early, and use that 
> > to decide how to make the generic call. Our experience has been that 
> > many firmware vendors only expect _OSC to be called once with any given 
> > UUID - multiple calls can result in unexpected behaviour.
> 
> acpi_bus_osc_support is called via subsys_initcall.  It is a little hard
> to do all checking before that.  Is it possible to call
> acpi_bus_osc_support later?

Yeah, this is going to be a problem. We have the HEST available at this 
point so we ought to be able to parse it, though. I'll take a look 
tomorrow.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
