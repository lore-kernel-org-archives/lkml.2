Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2EJNyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab2EJNyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:54:38 -0400
Date: Thu, 10 May 2012 09:54:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Subject: Re: [dm-devel] [Bcache v13 00/16]
Message-ID: <20120510135431.GC23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:
> bcache: a cache for arbitrary block devices using an SSD.
> 
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself as a
> new block device, a bit like say md. You can cache an arbitrary number of
> block devices with a single cache device, and attach and detach things at
> runtime - it's quite flexible.

So it is still not a device mapper target. I somehow had the impression
that consensus at LSF was to convert it into a device mapper target.

Thanks
Vivek
