Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1GVQ0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1GVQ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:26:21 -0400
Date: Fri, 22 Jul 2011 17:25:38 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
        akpm <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH -next] dm: fix dm-flakey printk warning
Message-ID: <20110722162538.GK5632@agk-dp.fab.redhat.com>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com,
	akpm <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au> <20110721161047.8a62d89a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721161047.8a62d89a.rdunlap@xenotime.net>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:10:47PM -0700, Randy Dunlap wrote:
> Fix printk format warning for sector_t, which can be (unsigned)
> long or long long.
 
Folded, thanks.

Alasdair

