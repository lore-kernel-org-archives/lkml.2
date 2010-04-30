Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0D3Uun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:50:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59468 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab0D3UtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:49:24 -0400
Date: Fri, 30 Apr 2010 21:49:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: MacBookPro2,2 unable too boot with the latest HEAD
Message-ID: <20100430204912.GA21240@srcf.ucam.org>
References: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com> <20100419142804.3cd53666.akpm@linux-foundation.org> <4BCCCCDF.4010605@gmail.com> <20100419145741.95688467.akpm@linux-foundation.org> <alpine.LFD.2.00.1004201011050.2402@sony> <4BD999C8.7090602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD999C8.7090602@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 07:38:00AM -0700, Justin P. Mattock wrote:

> This doesn't seem to be a big issue
> it's just one machine defaults to ac
> and then another machine defaults to battery
> (keep in mind both machines are iMac9,1's
> just different gpu's).

What do you mean, "Defaults to battery"? The iMac is a desktop machine, 
isn't it? There typically isn't an AC adapter present in the ACPI 
description.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
