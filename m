Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0CUP6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 11:58:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:40951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0CUP57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 11:57:59 -0400
Date: Sun, 21 Mar 2010 08:57:48 -0700 (PST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@dwoodhou-mobl2.ger.corp.intel.com
To: Ben Hutchings <ben@decadent.org.uk>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] pci/dmar: Tone down warnings about invalid BIOS DMAR
 tables
In-Reply-To: <1269183436.18314.150.camel@localhost>
Message-ID: <alpine.LFD.2.00.1003210854310.10882@dwoodhou-mobl2.ger.corp.intel.com>
References: <1269126097.18314.111.camel@localhost>  <1269126446.18314.117.camel@localhost>  <1269161010.4028.9824.camel@macbook.infradead.org> <1269183436.18314.150.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Ben Hutchings wrote:

> Are you saying that these bogus tables are found on boards that do have
> VT-d hardware?  I was working on the assumption that these tables result
> from the OEM building a BIOS with VT-d support for a board where the
> hardware is not present.

Yes. Most of these boards have VT-d but can't use it because the BIOS 
vendors fucked up and never once booted a VT-d-capable OS to test it. (And 
because the spec is bloody stupid and relies on BIOS tables rather than 
enumerating through PCI or something like that).

-- 
dwmw2

