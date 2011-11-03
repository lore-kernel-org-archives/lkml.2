Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab1KCHwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:52:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55762
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065Ab1KCHwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:52:13 -0400
Date: Thu, 3 Nov 2011 03:52:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3 of 5] virtio: support unlocked queue kick
Message-ID: <20111103075211.GD6993@infradead.org>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <c0db93dbb414ab6dbcde.1320306171@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0db93dbb414ab6dbcde.1320306171@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:12:51PM +1030, Rusty Russell wrote:
> Based on patch by Christoph for virtio_blk speedup:

Please credit it to Stefan - he also sent a pointer to his original
version in reply to the previous thread.

Also shouldn't virtqueue_kick have kerneldoc comments?


I also notices that you documented the functions bother here and in
the first patch in the headers.  At least historically the kerneldoc
tools didn't parse comments at declarations, but only at the function
defintions.  Did you check these actually get picked up?
