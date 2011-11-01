Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1KAOnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:43:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42425 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1KAOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:43:17 -0400
Date: Tue, 1 Nov 2011 14:43:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: ACPI ERROR SMBus or IPMI write requires Buff of len 66, found
 32...???? linux-3.0.0
Message-ID: <20111101144312.GA25790@srcf.ucam.org>
References: <4EAF1021.2090004@tlinx.org>
 <CAErSpo4GaQfoBWs2iPk1ppx69Ccnz3dZvt31vSp8R7zka8a6=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4GaQfoBWs2iPk1ppx69Ccnz3dZvt31vSp8R7zka8a6=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 08:05:49AM -0600, Bjorn Helgaas wrote:
> [+cc linux-acpi]
> 
> On Mon, Oct 31, 2011 at 3:16 PM, Linda Walsh <lkml@tlinx.org> wrote:
> >
> >
> > Was looking through boot log messages, and this one seemed 'new'...
> 
> Can you confirm that this error did not occur on a previous version?
> What is the most recent version where it did not occur?

ACPI IPMI support was only added recently, so it's not surprising that 
it didn't show up previously. The spec is quite clear that IPMI message 
buffers should be 66 bytes, but a lot of firmware seems to disagree. Not 
sure what the best thing to do here is.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
