Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1CGTFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:05:44 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:35619 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab1CGTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:05:42 -0500
Date: Mon, 7 Mar 2011 20:05:37 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Narendra K <narendra_k@dell.com>, linux-pci@vger.kernel.org
Subject: Re: linux-next: Tree for March 7
Message-ID: <20110307190537.GA5694@mako-laptop>
References: <20110307180547.0cd7b9eb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307180547.0cd7b9eb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 06:05:47PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20110304:

drivers/pci/pci-label.c: In function 'pci_create_firmware_label_files':
drivers/pci/pci-label.c:366: error: implicit declaration of function 'device_has_dsm'

Fails for !CONFIG_ACPI.

pci_create_firmware_label_files() uses device_has_dsm() which definition
is under #ifdef CONFIG_ACPI.

-- 
Mariusz Kozlowski
