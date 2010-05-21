Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab0EUPfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:35:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0EUPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:35:38 -0400
Date: Fri, 21 May 2010 11:35:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Message-ID: <20100521153538.GA1695@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-3-git-send-email-josef@redhat.com> <20100521152111.GB16049@infradead.org> <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:37:45AM -0400, Josef Bacik wrote:
> So after I sent this I thought that maybe I could make that test _only_ if we
> provide submit_bio, that way it only affects btrfs and not everybody else, would
> you prefer I do something like that?  I will make the commit log a bit more
> verbose.  Thanks,

Again, I think it's not really worth optimizing for.  Just document very
clearly why it's there.

