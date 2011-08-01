Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1HALXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:23:50 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43006
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab1HALXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:23:43 -0400
Date: Mon, 1 Aug 2011 07:23:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801112330.GA27190@infradead.org>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801020951.GA12870@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think Daves theory sounds good, but I'd like to get some evidence
for it.  We already have fairly good trace points in the writeback code,
but for this they aren't quite enough yet.  Curt posted some patches to
pass a why argument down the writeback stack so that we known the
high-level caller in all tracepoints.  I'll put that into my tree to
check where these calls come from.

