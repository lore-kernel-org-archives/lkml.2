Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1CGTwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:52:12 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:50101 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1CGTwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:52:10 -0500
X-Loopcount0: from 10.175.216.250
From: <Narendra_K@Dell.com>
To: <mk@lab.zgora.pl>
CC: <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Date: Mon, 7 Mar 2011 11:52:04 -0800
Subject: Re: linux-next: Tree for March 7
Thread-Topic: linux-next: Tree for March 7
Thread-Index: AcvdASIBP1K+PEnWRP6kqiBHMPlenQ==
Message-ID: <20110307201215.GB22450@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110307180547.0cd7b9eb.sfr@canb.auug.org.au>
 <20110307190537.GA5694@mako-laptop>
In-Reply-To: <20110307190537.GA5694@mako-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 12:35:37AM +0530, Mariusz Kozlowski wrote:
> On Mon, Mar 07, 2011 at 06:05:47PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20110304:
> 
> drivers/pci/pci-label.c: In function 'pci_create_firmware_label_files':
> drivers/pci/pci-label.c:366: error: implicit declaration of function 'device_has_dsm'
> 
> Fails for !CONFIG_ACPI.
> 
> pci_create_firmware_label_files() uses device_has_dsm() which definition
> is under #ifdef CONFIG_ACPI.
> 

Hello,

Sorry for the inconvenience. I sent a fix for this just now.

http://marc.info/?l=linux-next&m=129952710415436&w=2

With regards,
Narendra K