Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2GQQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:50:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52092
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2GQQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:50:28 -0400
Date: Tue, 17 Jul 2012 12:50:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention
 conditions
Message-ID: <20120717165026.GA30257@infradead.org>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
 <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
 <50044D56.6000400@redhat.com>
 <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
 <50052390.7030908@redhat.com>
 <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
 <5005285E.8060706@redhat.com>
 <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
 <20120717163612.GA15995@infradead.org>
 <50059713.7090606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50059713.7090606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 06:47:15PM +0200, Paolo Bonzini wrote:
> Il 17/07/2012 18:36, Christoph Hellwig ha scritto:
> >> > There's no such thing in the market today as a removable disk that's
> >> > resizeable.  Removable disks are for things like backup cartridges and
> >> > ageing jazz drives.  Worse: most removeable devices today are USB card
> >> > readers whose standards compliance varies from iffy to non existent.
> >> > Resizeable disks are currently the province of storage arrays.
> > The virtual disks exported by aacraid are both marked removable and
> > can be resized.
> 
> Do they report resizing via unit attention?  I can skip this part on
> removable virtio-scsi disks if that's what real hardware does, it would
> also work.

I don't have access to aacraid hardware currently.

