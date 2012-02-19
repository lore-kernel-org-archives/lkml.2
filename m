Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2BSW1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:27:40 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38529
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231Ab2BSW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:27:39 -0500
Date: Sun, 19 Feb 2012 17:27:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nam-Jae Jeon <linkinjeon@gmail.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Message-ID: <20120219222735.GA19971@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
 <20120217191522.GB13870@infradead.org>
 <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

thanks, your explanation makes sense.  Can you resend the patch with
the full description of what is going on? (or if Ben wants to edit it in
place before applying it's also fine with me).

Thanks a lot for tracking this down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
