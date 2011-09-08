Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1IHXew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:34:52 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37829
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755783Ab1IHXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:34:37 -0400
Date: Thu, 8 Sep 2011 11:54:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lin Ming <lxy@ss.pku.edu.cn>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
Message-ID: <20110908155448.GA23740@infradead.org>
References: <4E5B4AAF.2040101@samsung.com>
 <201109051704.12040.arnd@arndb.de>
 <CAH9JG2XST45QSmkbu4kqmuQ-vOS-xdwwz_w_CLepHYpA7z01cA@mail.gmail.com>
 <201109081747.52518.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109081747.52518.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 05:47:52PM +0200, Arnd Bergmann wrote:
> I would suggest that you specify exactly what you mean with REQ_GC at the
> point where it is defined, e.g.

Why would this be a request?  This seems like global action for the
device to me, and should have its own method.

