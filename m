Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0EYNGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:06:32 -0400
Received: from thunk.org ([69.25.196.29]:52820 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0EYNGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:06:31 -0400
Date: Tue, 25 May 2010 09:06:26 -0400
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 3/6] ext4: Use our own write_cache_pages()
Message-ID: <20100525130626.GD5556@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274784852-30502-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:54:09PM +1000, Dave Chinner wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> Make a copy of write_cache_pages() for the benefit of
> ext4_da_writepages().  This allows us to simplify the code some, and
> will allow us to further customize the code in future patches.

I'm going to be pushing this to Linus shortly, so it's likely you'll
be able to drop this from your patch series.  I just wanted to give
you a heads up about what I was planning on doing, which hopefully
simplified your life a little.

      	       	      	  	   	      - Ted
