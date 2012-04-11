Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436Ab2DKXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:09:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089Ab2DKXJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:09:24 -0400
Message-ID: <4F860F17.2090400@nod.at>
Date: Thu, 12 Apr 2012 01:09:11 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: swapoff() runs forever
References: <4F81F564.3020904@nod.at> <4F82752A.6020206@openvz.org> <4F82B6ED.2010500@nod.at> <alpine.LSU.2.00.1204091123380.1430@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204091123380.1430@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.04.2012 20:40, schrieb Hugh Dickins:
> I've not seen any such issue in recent months (or years), but
> I've not been using UML either.  The most likely cause that springs
> to mind would be corruption of the vmalloc'ed swap map: that would
> be very likely to cause such a hang.

It does not look like a swap map corruption.
If I restart most user space processes swapoff() terminates fine.
Maybe it is a refcounting problem?

> You say "recent Linux kernels": I wonder what "recent" means.
> Is this something you can reproduce quickly and reliably enough
> to do a bisection upon?
>

I can reproduce the issue on any UML kernel.
The oldest I've tested was 2.6.20.
Therefore, bug was not introduced by me. B-)

Thanks,
//richard
