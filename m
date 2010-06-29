Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0F2EBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:01:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49447 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab0F2EBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:01:50 -0400
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006281758070.16755@localhost.localdomain>
References: <1277136189.10998.63.camel@mulgrave.site>
	 <alpine.LFD.2.00.1006281758070.16755@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 23:01:47 -0500
Message-ID: <1277784107.10879.209.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 17:59 -0400, Len Brown wrote:
> Is this a production system with a production BIOS?

It's got a production BIOS, yes ... not sure about the system, it might
be a B model.

> BTW, "Instantly" here isn't actually instantly, it is
> "before the return from SMM".

ENOCONTEXT?

As I explained in the previous email, it takes about 1ms before it
reports as entered ACPI mode.

James


