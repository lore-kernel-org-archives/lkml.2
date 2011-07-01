Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1GAAis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:38:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56159 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1GAAir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:38:47 -0400
Date: Fri, 1 Jul 2011 01:38:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
Message-ID: <20110701003838.GB19738@srcf.ucam.org>
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>
 <20110622194324.GD8861@srcf.ucam.org>
 <w4sjr1v323.wl%peter@chubb.wattle.id.au>
 <4E0CC06E.7040204@zytor.com>
 <w4d3huc3va.wl%peter@chubb.wattle.id.au>
 <20110630235802.GA18584@srcf.ucam.org>
 <4E0D1239.70205@zytor.com>
 <20110701002221.GA19015@srcf.ucam.org>
 <w4iprmkfie.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w4iprmkfie.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 10:31:53AM +1000, Peter Chubb wrote:

> This machine was only ever shipped with Linux (Linpus) on it, AFAIK.

Bother. Your ACPI tables still make an _OSI query for Windows, even if 
it only ever booted Linux - but only if there's no _OSI Linux. So we 
could theoretically quirk it based on an OSI call for Linux followed by 
one for Windows (rather than the other way around), but I suspect that 
this is a specific enough case that a static quirk may be the easiest 
thing to do here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
