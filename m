Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab0FUQOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:14:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59892 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab0FUQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:14:53 -0400
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <1277136189.10998.63.camel@mulgrave.site>
References: <1277136189.10998.63.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 11:14:51 -0500
Message-ID: <1277136891.10998.67.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 11:03 -0500, James Bottomley wrote:
> The system in question has a set of root bridges, with the CD rom (which
> is seen) being on bus 0 and the SCSI controller, which doesn't show up
> being on bus 1 (with several other things on busses > 1).
> 
> The system uses ACPI to detect the multiple bridges, so it seems that
> this failure in 2.6.35-rc3:
> 
> ACPI: Core revision 20100428
> ACPI Error: Hardware did not enter ACPI mode (20100428/evxfevnt-103)
> ACPI Warning: AcpiEnable failed (20100428/utxface-147)
> ACPI: Unable to enable ACPI
> 
> Means that we can't detect any PCI bus other than 0 and thus the system
> won't boot.
> 
> The full dmesgs for a successful (2.6.34) and failed (2.6.35-rc3) boot
> are below.

This didn't make either the PCI or the ACPI lists ... probably because
of the attachments.  However, the full message (with attachments) is on
lkml:

http://marc.info/?l=linux-kernel&m=127713622821166

James


