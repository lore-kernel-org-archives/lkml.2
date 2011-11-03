Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1KCCEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:04:45 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41921 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932124Ab1KCCEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:04:40 -0400
Date: Wed, 2 Nov 2011 19:04:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-ID: <20111102190436.5b4c805a@jbarnes-desktop>
In-Reply-To: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 12:53:25 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> After merging the pci-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or directory
> 
> Caused by commit 571eba1b8aa9 ("PCI: Fix compile errors with PCI_ATS and !
> PCI_IOV").
> 
> You didn't build this, right? :-(  linux/export.h does not yet exist in
> Linus' tree ...  I have used the pci-current tree from next-20111102 for
> today.

Oh I thought Randy said this stuff was in -next already...  Sorry for
the trouble.

-- 
Jesse Barnes, Intel Open Source Technology Center
