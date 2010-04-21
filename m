Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0DUSWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:22:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50913 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0DUSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:22:12 -0400
Date: Wed, 21 Apr 2010 19:21:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ipmi: Only register one si per bmc
Message-ID: <20100421182154.GA16436@srcf.ucam.org>
References: <1271788828-10231-1-git-send-email-mjg@redhat.com> <1271788828-10231-2-git-send-email-mjg@redhat.com> <4BCF3F69.3050003@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF3F69.3050003@acm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 01:09:45PM -0500, Corey Minyard wrote:

> If I understand this correctly, this would really be "Only register one  
> si per system".  Unfortunately, there are systems that have more than  
> one BMC each with their own interface.

The spec explicitly says that while a system may have multiple BMCs, 
only one BMC may respond to GetDeviceID (6.11 of the 2.0 spec). Is the 
real world irritatingly incompatible with this?

> Also, I believe the driver would not function between the previous 
> patch and this patch, which isn't the best.

That's true. I can fix that up fairly easily.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
