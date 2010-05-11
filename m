Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0EKSdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:33:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53186 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0EKSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:33:48 -0400
Date: Tue, 11 May 2010 19:33:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Unconditionally set SCI_EN on resume
Message-ID: <20100511183343.GA19783@srcf.ucam.org>
References: <1273600165-16681-1-git-send-email-mjg@redhat.com> <201005112027.36923.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005112027.36923.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:27:36PM +0200, Rafael J. Wysocki wrote:

> No, this breaks my MSI Wind U100 right away.
> 
> If you called acpi_enable() before that and do that depending on its result,
> _that_ would work.

Calling acpi_enable breaks some HPs. What version of Windows did the 
Wind ship with?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
