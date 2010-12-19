Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0LSLhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 06:37:03 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46531 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0LSLhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 06:37:00 -0500
Date: Sun, 19 Dec 2010 04:36:58 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PCI / PCIe: Clear Root PME Status bits during early
	resume
Message-ID: <20101219113658.GH1263@parisc-linux.org>
References: <201012191149.40547.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012191149.40547.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 11:49:40AM +0100, Rafael J. Wysocki wrote:
> in pci_pm_default_resume_early() and not in the port's resume
> routine, because it's generally necessary even if the PCI Express
> port driver is not used).

We should make it impossible to not use the PCIe port driver.
(This isn't a reason to not take this patch for now, just a direction
we should be heading in for the future).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
