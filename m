Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab1LaH6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 02:58:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59841 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1LaH6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 02:58:01 -0500
Date: Sat, 31 Dec 2011 11:57:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111231075755.GR4806@moon>
References: <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon>
 <20111229161414.GC3516@google.com>
 <20111229162453.GC4806@moon>
 <CAGZ=bqLW7TvUESokP5Z-1bkXKidzwyGWi4_9-UyTptSxWhxKHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZ=bqLW7TvUESokP5Z-1bkXKidzwyGWi4_9-UyTptSxWhxKHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 11:55:29PM -0500, Kyle Moffett wrote:
...
> 
> Don't hexdump the key, just return pure binary and allow the user to
> encode it if they care (EG: files in "proc" would hexdump, but a
> syscall would not).  Also, I somehow suspect there is a preexisting
> function to do this for a byte array.
> 

Thanks a *lot* for comments, Kyle! I'll think about it and try to make
some draft prototype.

	Cyrill
