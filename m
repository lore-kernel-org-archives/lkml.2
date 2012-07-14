Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2GNHtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:49:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36844
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883Ab2GNHtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:49:14 -0400
Date: Sat, 14 Jul 2012 03:49:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
Message-ID: <20120714074911.GA31684@infradead.org>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send a version that does direct block I/O similar to xen-blkback
for now.  If we get proper in-kernel aio support one day you can add
back file backend support.

