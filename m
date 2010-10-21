Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0JUTx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:53:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0JUTxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:53:25 -0400
Date: Thu, 21 Oct 2010 21:49:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Behlendorf <behlendorf1@llnl.gov>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-ID: <20101021194917.GA14152@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov> <20101013213746.GA27248@redhat.com> <20101014121159.GA407@redhat.com> <1287683202.16680.44.camel@pip> <20101021181220.GA8827@redhat.com> <20101021122232.10d2d573.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021122232.10d2d573.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Andrew Morton wrote:
>
> Just to tie all this off, you originally said "We have a bug report
> which blames div64_u64() on 32bit platforms.".  Where is that bug report?

	Bug 616105 - problems with 64b division on 32b platforms.
	https://bugzilla.redhat.com/show_bug.cgi?id=616105

Oleg.

