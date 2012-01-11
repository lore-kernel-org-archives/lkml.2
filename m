Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2AKUeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:34:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51628 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2AKUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:34:29 -0500
Date: Thu, 12 Jan 2012 00:34:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
Message-ID: <20120111203423.GD28196@moon>
References: <20120111161939.GI8752@moon>
 <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
 <20120111175952.GI466@moon>
 <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
 <4F0DD365.6070200@parallels.com>
 <20120111183115.GA28196@moon>
 <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com>
 <m139bmxa9g.fsf@fess.ebiederm.org>
 <4F0DF001.6090903@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0DF001.6090903@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:24:33AM +0400, Pavel Emelyanov wrote:
> > In the second place the only reason why we would need O(N^2) complexity
> > instead of O(NlogN) is if the comparison system call only compares for
> > identity instead of returning a result that allows us to order the
> > objects we are worrying about.
> 
> Hm... I like this one. As I said we'd have to do the sorting anyway so
> having the less-equals-above comparator right in the kernel sounds OK.
> 

So it would look something like

	sys_cmp_kid(pid1, pid2, kid-type)

(where kid is kernel-id), right ? Or I miss something ?

	Cyrill
