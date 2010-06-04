Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0FDPLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:11:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab0FDPLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:11:02 -0400
Date: Fri, 4 Jun 2010 11:10:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 1/4] fs: cleanup files_lock
Message-ID: <20100604151057.GA11991@infradead.org>
References: <20100604064307.737085373@suse.de> <20100604072618.227745945@suse.de> <20100604083818.GA9987@infradead.org> <20100604142052.GD26335@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604142052.GD26335@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 12:20:52AM +1000, Nick Piggin wrote:
> Well it is already a special case, I just switched it to using a
> different lock for its private list. I wanted to keep surgery to
> a minimum.

You make it even more special.  Really, the right thing here is to
fix that hack for real.

