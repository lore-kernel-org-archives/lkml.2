Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2F2MaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:30:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42573 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2F2MaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:30:11 -0400
Date: Fri, 29 Jun 2012 13:30:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Srinivas_G_Gowda@Dell.com, tcminyard@gmail.com,
        linux-kernel@vger.kernel.org, openipmi@mvista.com
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Message-ID: <20120629123001.GA26545@srcf.ucam.org>
References: <4FEC8931.5020001@dell.com>
 <4FEC8A28.4070806@dell.com>
 <m2k3yrgf4d.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2k3yrgf4d.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 05:01:54PM -0700, Andi Kleen wrote:
> Not sure that's all that useful. I can just see BMC's making the ACPI
> mistake of trying to work around specific issues, by checking for
> Linux.
> 
> But since there are so many different Linux that will never work
> because "Linux" does not describe a fixed release or code base.
> 
> Probably dangerous.

Agreed. Linux doesn't make interface guarantees to hardware, and where 
we've implied that we do it's ended up breaking things.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
