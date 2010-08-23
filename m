Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0HWQrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:47:18 -0400
Received: from verein.lst.de ([213.95.11.210]:56071 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0HWQrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:47:17 -0400
Date: Mon, 23 Aug 2010 18:47:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Message-ID: <20100823164709.GA31221@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillipp and Lars,

can you look at the changes in

	http://www.spinics.net/lists/linux-fsdevel/msg35884.html

and

	http://www.spinics.net/lists/linux-fsdevel/msg36001.html

and see how drbd can be adapted to it?  It's one of two drivers still
missing, and because it's not quite intuitive what it's doing it's
very hard for Tejun and me to help.
