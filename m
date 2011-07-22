Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1GVBOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1GVBOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:14:21 -0400
Date: Fri, 22 Jul 2011 02:14:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] linux-next: Tree for July 21 (drivers/md/dm-raid)
Message-ID: <20110722011401.GH5632@agk-dp.fab.redhat.com>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au> <20110721145648.2477f8bb.rdunlap@xenotime.net> <20110722081040.48abfff1@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722081040.48abfff1@notabene.brown>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 08:10:40AM +1000, Neil Brown wrote:
> I suspect the right thing to do is add
>    select MD_RAID1
> to the 
>    config DM_RAID
 
Indeed - done.

Alasdair

