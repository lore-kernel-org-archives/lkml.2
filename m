Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab0LTQS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:18:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54590 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab0LTQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:18:28 -0500
Date: Mon, 20 Dec 2010 16:18:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] platform/x86: Kconfig: Replace select by depends on
	ACPI_WMI
Message-ID: <20101220161817.GE25502@srcf.ucam.org>
References: <AANLkTinbinQjvXo58hKDY4ZaMe1ZrGqWDbhoxdS+JLOG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinbinQjvXo58hKDY4ZaMe1ZrGqWDbhoxdS+JLOG@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks. It's easier to handle these if you include the patch in 
the email body, rather than as an attachment.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
