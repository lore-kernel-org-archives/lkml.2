Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab1LPAdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:33:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44082 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab1LPAdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:33:39 -0500
Date: Fri, 16 Dec 2011 00:33:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/4] ACPI: EC: Add ec_get_handle()
Message-ID: <20111216003333.GA18489@srcf.ucam.org>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
 <1323972371-13189-2-git-send-email-seth.forshee@canonical.com>
 <201112160122.36100.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112160122.36100.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 01:22:35AM +0100, Thomas Renninger wrote:

> I think best is to move the thinkpad implementation of getting
> ACPI handles based on HIDs to osl.c and make it global.
> I'll send patches.
> Please review them carefully, they are only compile tested.

The ec driver is already finding the hardware on the basis of the HID - 
is there any reason to do this twice rather than just exporting the 
information the ec driver already has?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
