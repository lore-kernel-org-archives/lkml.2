Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0FATVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:21:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35141 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0FATVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:21:12 -0400
Date: Tue, 1 Jun 2010 20:21:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100601192101.GA15086@srcf.ucam.org>
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com> <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C055BFF.8090800@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 12:14:07PM -0700, Justin P. Mattock wrote:

> o.k. applied.. unfortunately
> I get init telling me it's rebooting,
> then, nothing but a black screen.

Could you send me the output of acpidump on this machine? Also, try 
building the following app and running it as root:

#include <sys/io.h>

int main() {
	outb(6, 0xcf9);
	return 0;
}

and see if the machine reboots.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
