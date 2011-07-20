Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1GTKBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:01:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1GTKBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:01:30 -0400
Date: Wed, 20 Jul 2011 12:01:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the staging tree with the trivial
 tree
In-Reply-To: <20110717091600.GD25824@kroah.com>
Message-ID: <alpine.LNX.2.00.1107201201020.7300@pobox.suse.cz>
References: <20110716225343.4a0a0472fb944c9ba79f9590@canb.auug.org.au> <20110717091600.GD25824@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011, Greg KH wrote:

> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/generic_serial/ser_a2232.c between commit 28f65c11f2ff
> > ("treewide: Convert uses of struct resource to resource_size(ptr)") from
> > the trivial tree and commit bb2a97e9ccd5 ("Staging: delete generic_serial
> > drivers") from the staging tree.
> > 
> > The latter removes the file, so I did that.
> 
> Thank you, that is the correct fix :)

I have dropped the conflicting hunks now (and the same for the other 
trivial/staging conflict).

Thanks,

-- 
Jiri Kosina
SUSE Labs
