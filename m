Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab1F3I4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:56:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49873
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab1F3I4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:56:39 -0400
Date: Thu, 30 Jun 2011 04:56:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Message-ID: <20110630085633.GA31414@infradead.org>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
 <20110629140630.5aefdda8.rdunlap@xenotime.net>
 <BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
 <20110630080119.GA20802@infradead.org>
 <BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 10:43:47AM +0200, Geert Uytterhoeven wrote:
> > Better fix the code to use the proper %zd specifier for printing ssize_t
> > variables.
> 
> We cannot, as that would break on all other platforms that use the
> correct ssize_t.

%zd is specified as the correct format for ssize_t.

