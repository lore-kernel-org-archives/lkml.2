Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab1EZXtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:49:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:50570 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218Ab1EZXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:48:59 -0400
To: nab@linux-iscsi.org
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,
        hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu,
        bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz,
        jxm@risingtidesystems.com
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1306452490.23461.60.camel@haakon2.linux-iscsi.org>
References: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
	<1306451068.4048.69.camel@mulgrave.site>
	<1306452490.23461.60.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 27 May 2011 08:47:52 +0900
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 May 2011 08:48:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 16:28:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> As we have discussed at length over the years, the split needs to be all
> userspace or all kernelspace, and when implementations start doing
> things in-between they quickly get painful to debug, maintain and
> extend.  I have no interest in trying to evolve this further when LIO

Sorry, I disagree. As I explained, once user space passes established nexuses
to kernel, kernel handles all. I don't think it's painful.


> from the default two cases provided in their series, but lets please,
> please avoid slipping yet another window here when we still have >= 15K
> LOC in three other HW target mode fabric drivers in flight for the next
> round

Why can't you push other fabric drivers before iSCSI one?
