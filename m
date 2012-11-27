Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2K0OtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:49:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab2K0OtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:49:01 -0500
Date: Tue, 27 Nov 2012 14:48:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] balancenuma: set last_nid on newly allocated page
Message-ID: <20121127144858.GR8218@suse.de>
References: <CAJd=RBD-5zq-7U3yPWCsb9P_AMzf_GoT47onxXiihgK9J7-wOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBD-5zq-7U3yPWCsb9P_AMzf_GoT47onxXiihgK9J7-wOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 09:15:44PM +0800, Hillf Danton wrote:
> Pass last_nid from misplaced page to newly allocated migration target page.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Picked up. One part if it gets slotted into place as a standalone patch.
The second became part of the THP patch at the end of the series. Same
logic as before -- preserves bisection and allows the tree to be tested
in pieces.

Thanks Hillf!

-- 
Mel Gorman
SUSE Labs
