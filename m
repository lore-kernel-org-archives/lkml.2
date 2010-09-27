Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0I0FVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:21:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:60623 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0I0FVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:21:23 -0400
Date: Mon, 27 Sep 2010 14:20:16 +0900
To: ddaney@caviumnetworks.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, mingo@elte.hu,
        andre.goddard@gmail.com
Subject: Re: [PATCH 7/9] swiotlb: Make bounce buffer bounds non-static.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1285282051-24907-2-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
	<1285282051-24907-2-git-send-email-ddaney@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100927141616S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 27 Sep 2010 14:20:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 15:47:31 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> Octeon PCI mapping has to be established to cover the bounce buffers,
> so it has to have access to the bounds.

Why can't you use swiotlb_init_with_tbl() instead?
