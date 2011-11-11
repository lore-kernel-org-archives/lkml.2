Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab1KKInY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:43:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41462 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1KKInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:43:23 -0500
Date: Fri, 11 Nov 2011 08:42:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: benh@kernel.crashing.org, nai.xia@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
        dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        lethal@linux-sh.org
Subject: Re: mm: convert vma->vm_flags to 64bit
Message-ID: <20111111084251.GZ12913@n2100.arm.linux.org.uk>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com> <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com> <4EBC085D.3060107@jp.fujitsu.com> <1320959579.21206.24.camel@pasglop> <4EBC46FD.5010109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC46FD.5010109@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 04:49:49PM -0500, KOSAKI Motohiro wrote:
> Maybe we need to ban useless arch specific flags at first.

Maybe a separate vma->vm_arch_flags for them if arches really want this?
