Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1IHInF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:43:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40293
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab1IHInB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:43:01 -0400
Date: Thu, 8 Sep 2011 04:42:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110908084257.GB4032@infradead.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <201109071602.24519.sgrubb@redhat.com>
 <20110907211858.GE20571@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907211858.GE20571@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:18:58PM -0400, Ted Ts'o wrote:
> If this is the basis for the patch, then we should definitely NACK it.
> It sounds like snake oil fear mongering.

You're around long enough to know that Steve and his gang do nothing but
selling snake oil.
