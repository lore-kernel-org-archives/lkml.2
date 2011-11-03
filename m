Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab1KCHt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:49:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55745
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab1KCHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:49:57 -0400
Date: Thu, 3 Nov 2011 03:49:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 5] virtio: document functions better
Message-ID: <20111103074952.GB6993@infradead.org>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <7ce2cceb12e0dd2a4c99.1320306169@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ce2cceb12e0dd2a4c99.1320306169@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:12:49PM +1030, Rusty Russell wrote:
> The old documentation is left over from when we used a structure with
> strategy pointers.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
