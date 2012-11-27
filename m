Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2K0Omf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:42:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab2K0Ome (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:42:34 -0500
Date: Tue, 27 Nov 2012 14:42:31 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] balancenuma: set last_nid on tail page
Message-ID: <20121127144231.GQ8218@suse.de>
References: <CAJd=RBD8VJJ75BHR9+KogGtOwaZf36Br9_ehj7oLCcCw9Qiuew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBD8VJJ75BHR9+KogGtOwaZf36Br9_ehj7oLCcCw9Qiuew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 09:22:12PM +0800, Hillf Danton wrote:
> Pass last_nid from head page to tail page.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Thanks. Picked up now.

-- 
Mel Gorman
SUSE Labs
