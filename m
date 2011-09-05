Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1IEJPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:15:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53128
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab1IEJPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:15:49 -0400
Date: Mon, 5 Sep 2011 05:15:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lin Ming <lxy@ss.pku.edu.cn>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
Message-ID: <20110905091540.GA22014@infradead.org>
References: <4E5B4AAF.2040101@samsung.com>
 <CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
 <4E5B65C6.6070300@samsung.com>
 <CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
 <CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
 <CAH9JG2W+wEfpL6baQmvigcH9LRn6p0wTszK+urPKxpNfHsjUCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2W+wEfpL6baQmvigcH9LRn6p0wTszK+urPKxpNfHsjUCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So what the heck is a tunable request supposed to be?  How does it
qualify for beeing a generic request/bio type?

