Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1IHII4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:08:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51101
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab1IHIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:08:53 -0400
Date: Thu, 8 Sep 2011 04:08:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: hch@infradead.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110908080843.GA14549@infradead.org>
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com>
 <20110907201620.GB26548@infradead.org>
 <4E6892B4020000780005536B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6892B4020000780005536B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:02:28AM +0100, Jan Beulich wrote:
> That would need to be done in the backend, as the expectation cannot
> be to patch old frontends to deal with new backends.

Sorry, I meant blkback above.

