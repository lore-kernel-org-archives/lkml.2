Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0EYMjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:39:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55747 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0EYMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:39:19 -0400
Date: Tue, 25 May 2010 13:39:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Yu, Luming" <luming.yu@intel.com>
Cc: Len Brown <lenb@kernel.org>, Philip Langdale <philipl@overt.org>,
       Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "venki@google.com" <venki@google.com>
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100525123905.GB7876@srcf.ucam.org>
References: <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org> <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain> <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 01:59:39PM +0800, Yu, Luming wrote:

> On some platforms like NHM-EX, I was told that it's a NOP,
> But I might be given wrong information at that time when I wrote that patch.
> 
> IIRC, acpi spec just say it's optional..

Implementing it is optional, but the spec implies that it should be used 
if it's present.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
