Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HYGGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:06:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43266
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab1HYGGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:06:33 -0400
Date: Thu, 25 Aug 2011 02:06:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk,
        dchinner@redhat.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110825060632.GA9933@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275199-10801-5-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> This is a test to make sure seek_data/seek_hole is acting like it does on
> Solaris.  It will check to see if the fs supports finding a hole or not and will
> adjust as necessary.

Can you resend this with any updates that happened in the meantime?

Dave also still had some comments about semantics, so it might be worth
to incorporate that as well.

