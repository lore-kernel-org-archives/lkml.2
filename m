Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1JXXSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 19:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1JXXSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 19:18:36 -0400
Date: Mon, 24 Oct 2011 19:18:29 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Message-ID: <20111024231829.GB25993@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <JBottomley@parallels.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
 <1319496149.2094.3.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319496149.2094.3.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:42:29PM -0700, Joe Perches wrote:
 > James seems to be uninterested in picking up
 > obvious and trivially correct patches.
 > 
 > >From a year ago...
 > 
 > https://lkml.org/lkml/2010/10/31/123
 > 
 > James?
 
That's just ridiculous.
If maintainers aren't picking up obviously correct fixes[*], just send
them directly to Linus or Andrew.

	Dave

[*] Functional changes only, not janitor stuff. Just the patches fixing
    actual bugs.
