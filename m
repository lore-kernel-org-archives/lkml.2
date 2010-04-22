Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0DVXRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:17:54 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45807 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753918Ab0DVXRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:17:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UZUkcSdZ9zrPvl9VHWBoJK07DEzqfNUPE/5EV1QJwXBbrXnaK4zQpTrpNX+s6yJw7zxNbZurhQ0xCNYSg9eL3azZwjQSG50lHiynSTXjTtcwevm3IhbrMepiJDjB6A5/;
Date: Thu, 22 Apr 2010 16:17:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86/PCI: parse additional host bridge window resource
 types
Message-ID: <20100422161749.5e8af128@virtuousgeek.org>
In-Reply-To: <20100420195241.13265.93577.stgit@bob.kio>
References: <20100420195241.13265.93577.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 13:52:41 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> This adds support for Memory24, Memory32, and Memory32Fixed descriptors in
> PCI host bridge _CRS.
> 
> I experimentally determined that Windows (2008 R2) accepts these descriptors
> and treats them as windows that are forwarded to the PCI bus, e.g., if
> it finds any PCI devices with BARs outside the windows, it moves them into
> the windows.
> 
> I don't know whether any machines actually use these descriptors in PCI
> host bridge _CRS methods, but if any exist and they're new enough that we
> automatically turn on "pci=use_crs", they will work with Windows but not
> with Linux.
> 
> Here are the details: https://bugzilla.kernel.org/show_bug.cgi?id=15817
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied to for-linus, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
