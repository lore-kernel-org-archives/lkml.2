Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1GAAWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:22:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47651 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab1GAAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:22:37 -0400
Date: Fri, 1 Jul 2011 01:22:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
Message-ID: <20110701002221.GA19015@srcf.ucam.org>
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>
 <20110622194324.GD8861@srcf.ucam.org>
 <w4sjr1v323.wl%peter@chubb.wattle.id.au>
 <4E0CC06E.7040204@zytor.com>
 <w4d3huc3va.wl%peter@chubb.wattle.id.au>
 <20110630235802.GA18584@srcf.ucam.org>
 <4E0D1239.70205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0D1239.70205@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 05:18:01PM -0700, H. Peter Anvin wrote:

> It might be a RESET versus INIT difference... if the "PCI reboot" (which
> is what "ACPI reboot") points to, it might end up pulling INIT, whereas
> the keyboard controller pulls RESET.
> 
> RESET would forcibly initialize the hardware state of the machine,
> obviously...

I guess I'm going to have to go back and retest the XP behaviour. I'd 
expect this machine to be using the ACPI vector there too.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
