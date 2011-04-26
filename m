Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1DZIZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:25:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:38326 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1DZIZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:25:09 -0400
Date: Tue, 26 Apr 2011 10:25:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] treewide: Cleanup continuations and remove
 logging message whitespace
In-Reply-To: <20110425082230.6d656ed0.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.2.00.1104261024540.12035@pobox.suse.cz>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com> <20110425082230.6d656ed0.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Randy Dunlap wrote:

> > Using C line continuation inside format strings is error prone.
> > Clean up the unintended whitespace introduced by misuse of \.
> > Neaten correctly used line continations as well for consistency.
> > 
> > drivers/scsi/arcmsr/arcmsr_hba.c has these errors as well,
> > but arcmsr needs a lot more work and the driver should likely be
> > moved to staging instead.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
