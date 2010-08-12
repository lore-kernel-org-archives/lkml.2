Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab0HLQGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:06:41 -0400
Received: from verein.lst.de ([213.95.11.210]:44855 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328Ab0HLQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:06:39 -0400
Date: Thu, 12 Aug 2010 18:05:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2] MD: raid, fix BUG caused by flags handling
Message-ID: <20100812160540.GA28689@lst.de>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for sending this again.  It's been sent at least twice before,
but we really need to get it into the block tree, and now that it's been
merged to mainline there, too.


Reviewed-by: Christoph Hellwig <hch@lst.de>

