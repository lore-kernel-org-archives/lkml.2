Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2DAAJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 20:09:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41228
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab2DAAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 20:09:16 -0400
Date: Sat, 31 Mar 2012 20:09:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc1
Message-ID: <20120401000915.GA8878@infradead.org>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 04:58:35PM -0700, Linus Torvalds wrote:
>  - pohmelfs. The old pohmelfs got deleted from staging, there's an
> all-new one waiting in the sidelines. Al was a bit unhappy about some
> of it, Evgeniy fixed it up some, and then the discussion died. Again,
> I'm likely to pull this, but I wanted more commentary on it.

I haven't looked at the code, but given that the old one basically
bitrotted after it got merged and I've not even heard about any
users of it I would suggest not to merge it for now. 

