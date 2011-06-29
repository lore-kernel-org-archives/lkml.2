Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1F2VYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:24:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44100
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263Ab1F2VY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:24:28 -0400
Date: Wed, 29 Jun 2011 17:24:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, xfs-masters@oss.sgi.com,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (xfs on cris)
Message-ID: <20110629212420.GA9822@infradead.org>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
 <20110629142106.447393a5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629142106.447393a5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:21:06PM -0700, Randy Dunlap wrote:
> Looks like arch/cris does not support atomic64_t.  (?)
> 
> Should we prevent xfs from being built on arch/cris?

Or nuke cris until it's able to at least include an asm-generic header?

