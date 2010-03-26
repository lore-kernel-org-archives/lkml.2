Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0CZOnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:43:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31566 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0CZOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:43:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the pci tree with the pci-current tree
Date: Fri, 26 Mar 2010 08:43:35 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100326115712.2d800053.sfr@canb.auug.org.au>
In-Reply-To: <20100326115712.2d800053.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003260843.35458.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010 06:57:12 pm Stephen Rothwell wrote:
> Hi Jesse,
> 
> Today's linux-next merge of the pci tree got a conflict in
> arch/x86/pci/acpi.c between commit
> eb9fc8ef7cb1362374e55d9503e3e7458f319991 ("x86/PCI: for host bridge
> address space collisions, show conflicting resource") from the
> pci-current tree and commit 7589c4d809ccfc88100ba224e3358706fd21f37e
> ("x86/PCI: trim _CRS windows when they conflict with previous
> reservations") from the pci tree.

I'm sure Jesse has straightened this out already, but my intent
was to drop the "trim _CRS windows when they conflict" patch.

I replaced it with one called "truncate _CRS windows with _LEN >
_MAX - _MIN + 1".

Bjorn
