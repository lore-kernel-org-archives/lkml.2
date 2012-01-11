Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2AKU0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:26:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45507 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab2AKU0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:26:12 -0500
Message-ID: <4F0DF001.6090903@parallels.com>
Date: Thu, 12 Jan 2012 00:24:33 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
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
References: <20120111161939.GI8752@moon>	<CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>	<20120111175952.GI466@moon>	<CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>	<4F0DD365.6070200@parallels.com> <20120111183115.GA28196@moon>	<CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com> <m139bmxa9g.fsf@fess.ebiederm.org>
In-Reply-To: <m139bmxa9g.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the second place the only reason why we would need O(N^2) complexity
> instead of O(NlogN) is if the comparison system call only compares for
> identity instead of returning a result that allows us to order the
> objects we are worrying about.

Hm... I like this one. As I said we'd have to do the sorting anyway so
having the less-equals-above comparator right in the kernel sounds OK.

Thanks,
Pavel
