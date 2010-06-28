Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0F2APq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:15:46 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:35082 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0F2APo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:15:44 -0400
Date: Mon, 28 Jun 2010 17:59:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
In-reply-to: <1277136189.10998.63.camel@mulgrave.site>
Message-id: <alpine.LFD.2.00.1006281758070.16755@localhost.localdomain>
References: <1277136189.10998.63.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,
Is this a production system with a production BIOS?

BTW, "Instantly" here isn't actually instantly, it is
"before the return from SMM".

thanks,
Len Brown, Intel Open Source Technology Center

