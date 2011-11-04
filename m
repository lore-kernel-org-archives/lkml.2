Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1KDVD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:03:26 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36132
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab1KDVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:03:25 -0400
Date: Fri, 4 Nov 2011 17:03:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111104210324.GB14983@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
 <20111021132240.GA24136@infradead.org>
 <20111021202857.GB30100@hostway.ca>
 <20111024082219.GA19941@infradead.org>
 <20111025200748.GA25043@hostway.ca>
 <20111026112521.GA10432@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026112521.GA10432@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Simon,

I haven't really been able to get back to this as fast as I wanted to
do.  Can you do another run and check if the patch still helps your
issue even if you remove the xfs_log_force line?

