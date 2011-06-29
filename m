Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1F2RhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:37:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52998
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279Ab1F2Rg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:36:56 -0400
Date: Wed, 29 Jun 2011 13:36:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: P?draig Brady <P@draigBrady.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110629173648.GA22293@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110629065306.GC1026@dastard>
 <20110629074021.GA26086@infradead.org>
 <4E0B019E.8080800@draigBrady.com>
 <4E0B60DE.50908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0B60DE.50908@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:29:02AM -0700, Sunil Mushran wrote:
> I'm not too sure about that. Atleast not enabled by default. Most users
> use cp to backup data. Not empty space. In this case, this empty extent
> may not even be de-dupable.
> 
> Frankly I'd be happier of cp started to exploited fallocate() to create larger
> extents before copying data into them. Atleast for the large files.

That's what delayed allocation is for.
