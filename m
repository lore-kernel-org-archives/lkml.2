Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1IOOff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:35:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33801
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab1IOOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:35:34 -0400
Date: Thu, 15 Sep 2011 10:35:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110915143528.GA15980@infradead.org>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
 <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
 <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
 <20110912143452.GA31539@infradead.org>
 <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
 <20110912153129.GA10625@infradead.org>
 <CAG1a4rsKQexL8vhAAoJDtnEvqH0rDvPQCiBGM74EH-+pZ9+WPg@mail.gmail.com>
 <20110914174250.GA30240@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914174250.GA30240@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 01:42:50PM -0400, Christoph Hellwig wrote:
> I'll switch everything to PAGE_SIZE in the patch for consistency.

I'll take that back.  hfsplus is mostly using PAGE_CACHE_SIZE and
friends, so I'll fix the few uses of plain PAGE_SIZE instead.  But
that's 3.2 material.

