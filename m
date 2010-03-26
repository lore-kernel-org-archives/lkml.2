Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0CZCLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:11:25 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:41587 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752642Ab0CZCLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:11:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LNJalka2f0njo3dyMAMTRzelT40BcXXwrVF+ByTiEBEf2W0L7XBb8pMO9rTSjGkJhM74MzJ3z9J1lcihEmeG13PpcWC1c+IgjAqZCkJHJXnRv84IJl2YQLSyV4tSh7Zr;
Date: Thu, 25 Mar 2010 19:10:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: linux-next: manual merge of the pci tree with the pci-current
 tree
Message-ID: <20100325191049.18020272@jbarnes-piketon>
In-Reply-To: <20100326115712.2d800053.sfr@canb.auug.org.au>
References: <20100326115712.2d800053.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 11:57:12 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next merge of the pci tree got a conflict in
> arch/x86/pci/acpi.c between commit
> eb9fc8ef7cb1362374e55d9503e3e7458f319991 ("x86/PCI: for host bridge
> address space collisions, show conflicting resource") from the
> pci-current tree and commit 7589c4d809ccfc88100ba224e3358706fd21f37e
> ("x86/PCI: trim _CRS windows when they conflict with previous
> reservations") from the pci tree.
> 
> I fixed it up (by using the pci tree version) and can carry the fix for a
> while.

Time to rebase my -next branch onto my for-linus branch again I guess.

-- 
Jesse Barnes, Intel Open Source Technology Center
