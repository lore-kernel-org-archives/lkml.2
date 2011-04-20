Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1DTKzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:55:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1DTKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:55:12 -0400
Date: Wed, 20 Apr 2011 06:55:09 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: "hch@infradead.org" <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110420105509.GB31203@infradead.org>
References: <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
 <20110418183343.036f412e@notabene.brown>
 <20110418213048.GA21852@infradead.org>
 <20110419083813.5c61aa99@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419083813.5c61aa99@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 08:38:13AM +1000, NeilBrown wrote:
> Is that at all close to what you are thinking?

Yes, pretty much like that.

