Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2FNDUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:20:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52375 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab2FNDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:20:16 -0400
Date: Thu, 14 Jun 2012 12:20:05 +0900
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1339623535.3321.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339623535.3321.4.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:38:55PM +0200, Sasha Levin wrote:
> Hi all,
> 
> I'm seeing the following when booting a KVM guest with 65gb of RAM, on latest linux-next.
> 
> Note that it happens with numa=off.
> 
> [    0.000000] BUG: unable to handle kernel paging request at ffff88102febd948
> [    0.000000] IP: [<ffffffff836a6f37>] __next_free_mem_range+0x9b/0x155

Can you map it back to the source line please?

Thanks.

-- 
tejun
