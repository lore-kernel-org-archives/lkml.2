Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0LIPR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:17:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46840 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0LIPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:17:28 -0500
Date: Thu, 9 Dec 2010 15:16:33 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Edouard Gomez <ed.gomez@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Backlund <tmb@mandriva.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
Message-ID: <20101209151633.GA7273@srcf.ucam.org>
References: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My testing suggests that Windows never uses the BIOS-style reboot 
approach, so this seems wrong. Does reboot=acpi work for you?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
