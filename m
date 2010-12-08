Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0LHXNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:13:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:55106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0LHXNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:13:53 -0500
Date: Wed, 8 Dec 2010 15:10:49 -0800
From: Greg KH <gregkh@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [121/127] [S390] nmi: fix clock comparator revalidation
Message-ID: <20101208231049.GA8196@suse.de>
References: <20101208004456.GA23578@kroah.com>
 <20101208004436.427324416@clark.site>
 <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:04:28AM +0100, Heiko Carstens wrote:
> This line won't compile on 2.6.32. That's why I sent a slightly different
> patch to -stable (and also the reason why I removed Martin's Sign-off) ;)
> 
> Here is the version I sent to stable@kernel.org again:

Now updated.

thanks,

greg k-h
