Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab2IUTHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:07:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50042 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab2IUTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:07:33 -0400
Date: Fri, 21 Sep 2012 14:56:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
Message-ID: <20120921185622.GA5042@phenom.dumpdata.com>
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
 <20120921184123.GA27502@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921184123.GA27502@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *: With a PVHVM guest I get
> 
> [  261.927218] privcmd_fault: vma=ffff88002a31dce8 7f4edc095000-7f4edc195000, pgoff=c8, uv=00007f4edc15d000
> 
> thought if I applied your patch on top of v3.6-rc6 I didn't see the privcmd_fault but
> I did see the guest crash.

And that is due to c571898ffc24a1768e1b2dabeac0fc7dd4c14601 which I've reverted in my
#linux-next branch
