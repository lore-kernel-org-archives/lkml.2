Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728Ab2FVVke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:40:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58457 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2FVVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:40:33 -0400
Date: Fri, 22 Jun 2012 23:40:19 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@debianer
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-scsi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [set5 PATCH 2/6] async: make async_synchronize_full() flush all
 work regardless of domain
In-Reply-To: <20120622064707.21538.22198.stgit@dwillia2-linux.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1206222333050.1141@debianer>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com> <20120622064707.21538.22198.stgit@dwillia2-linux.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Jun 2012, Dan Williams wrote:
> In response to an async related regression James noted:
> 
>   "My theory is that this is an init problem: The assumption in a lot of
>    our code is that async_synchronize_full() waits for everything ... even
>    the domain specific async schedules, which isn't true."
> 
> ...so make this assumption true.

Hi Dan,

I've applied the all 6 patches of this set. 
(HEAD 8874e812feb4926f4a51a82c4fca75c7daa05fc5 , Linus' tree)

I've tested it on the same setup and everything runs fine, and I've 
seen no suspicious messages.

If you'd like, I can test only patch #2 in isolation.

Tested-by: Eldad Zack <eldad@fogrefinery.com>

Best regards,
Eldad
