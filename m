Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2EAVmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:42:33 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:33881 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755417Ab2EAVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:42:30 -0400
Date: Wed, 2 May 2012 01:42:19 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: omap_hdq: use wait_event_timeout to wait for
 read to complete.
Message-ID: <20120501214219.GB15560@ioremap.net>
References: <20120425124153.2afa318b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425124153.2afa318b@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:41:53PM +1000, NeilBrown (neilb@suse.de) wrote:
> There is no gain in having a loop - there is no risk of missing the
> interrupt with wait_event_timeout.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Both patches look good, thank you
Feel free to add my ack if needed

-- 
	Evgeniy Polyakov
