Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966596Ab2ERTDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:03:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781Ab2ERTDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:03:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the pm tree with Linus' tree
Date: Fri, 18 May 2012 21:08:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@amd.com>
References: <20120518154800.3b8cae2960234e03bee0101e@canb.auug.org.au>
In-Reply-To: <20120518154800.3b8cae2960234e03bee0101e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182108.01664.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, May 18, 2012, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/acpi/scan.c between commit 5c7dd710f691 ("ACPI / PCI / PM: Fix
> device PM regression related to D3hot/D3cold") from the  tree and commit
> 6ef564fd2070 ("ACPI / PM: Evaluate _PS3 when entering D3 Cold") from the
> pm tree.
> 
> I fixed it up (by using the version from Linus' tree) and can carry the
> fix as necessary.

Thanks, I'm dropping the conflicting patch from the pm tree.

Rafael
