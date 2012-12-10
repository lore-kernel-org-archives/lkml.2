Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2LJV5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:57:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2LJV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:57:52 -0500
Message-ID: <50C65AC6.9050904@oracle.com>
Date: Mon, 10 Dec 2012 16:57:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] remove kvm's use of augmented rbtree
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com> <CA+1xoqfu=hw--46Ae+VrP8Xt7Rdozv5TtPvGvhcJr94VVmJQ_A@mail.gmail.com> <CA+1xoqdtvq7WQf_1EoGjBo9Rjd1YHS4eSqQX2o-nnYNoMuCzzg@mail.gmail.com> <CANN689Gy3nLBasBea-nqkK7zTC4XuhUKH=FmOTcq_pKWPi_xmw@mail.gmail.com>
In-Reply-To: <CANN689Gy3nLBasBea-nqkK7zTC4XuhUKH=FmOTcq_pKWPi_xmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 04:50 PM, Michel Lespinasse wrote:
> On Mon, Dec 10, 2012 at 8:22 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Ping?
> 
> Hey Sasha,
> 
> There seems to have been some confusion here. After your last message,
> I expected *you* to take the patches and push them towards kvm tree.
> But, I guess you were waiting for Pekka's reply first ? Or did you
> expect me to go push the patches ?
> 
> If it helps, I could push this through Andrew's -mm tree; however I
> think it would make the most sense if these could reach linus's tree
> through a kvm merge rather than through Andrew's -mm...

Ah, no, Pekka is the one taking care of the KVM tools tree, so I'm we're waiting
for him to take a look at the patches and take them if they look fine to him :)


Thanks,
Sasha

