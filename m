Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0LIGXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:23:10 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:38730 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0LIGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:23:08 -0500
Date: Thu, 9 Dec 2010 07:23:04 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [121/127] [S390] nmi: fix clock comparator revalidation
Message-ID: <20101209062304.GA10183@osiris.boeblingen.de.ibm.com>
References: <20101208004456.GA23578@kroah.com>
 <20101208004436.427324416@clark.site>
 <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
 <20101208171331.GA12918@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208171331.GA12918@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:13:31AM -0800, Greg KH wrote:
> On Wed, Dec 08, 2010 at 09:04:28AM +0100, Heiko Carstens wrote:
> > This line won't compile on 2.6.32. That's why I sent a slightly different
> > patch to -stable (and also the reason why I removed Martin's Sign-off) ;)
> 
> Ah, please be more clear that you are sending a modifed version for me
> to apply instead of taking the upstream patch directly, which is the
> default for me to do so in order to make sure nothing is incorrect.

Ok, will do next time. Sorry for the confusion.
