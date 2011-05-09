Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1EITax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:30:53 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56343 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753555Ab1EITav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:30:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bCyykSRVYyzYtj8OjYqdmPu7TIdp0i5lHxPFtPB26/FSL3bqCGvUjlDNrDE/qOMq96+QNzfMuSGODHxacfaJrJWtHOTWDXYT8x+VIPV/HzoCjQgvjcYp7YrePsJxWpeF;
Date: Mon, 9 May 2011 12:30:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / ACPI: Report _OSC control mask returned on
 failure to get control
Message-ID: <20110509123036.170bfbd1@jbarnes-desktop>
In-Reply-To: <201104300021.38386.rjw@sisk.pl>
References: <201104300021.38386.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 00:21:38 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If an attempt to get _OSC control of the PCIe native features from
> the BIOS fails, report the resulting mask of control flags the BIOS
> was willing to grant in the error message.  Moreover, if the _OSC
> support mask is insufficient for requesting control of the PCIe
> native features or pcie_ports_disabled is set, print a diagnostic
> message containing the _OSC support mask.  This helps to diagnose
> obscure _OSC-related problems on a number machines.

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
