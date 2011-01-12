Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1ALXMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:12:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1ALXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:12:32 -0500
Date: Wed, 12 Jan 2011 23:12:15 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] linux-next: Tree for January 12 (dm-crypt)
Message-ID: <20110112231215.GC9501@agk-dp.fab.redhat.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110112141822.c29314c4.sfr@canb.auug.org.au> <20110112100121.ba610465.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112100121.ba610465.randy.dunlap@oracle.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:01:21AM -0800, Randy Dunlap wrote:
> When CONFIG_LBDAF is not enabled (build on i386):
> (sector_t is 32 bits)
> 
> drivers/md/dm-crypt.c:568: warning:right shift count >= width of type
 
Thanks - being fixed.

Alasdair

