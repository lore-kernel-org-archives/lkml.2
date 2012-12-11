Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2LKKaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:30:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37095 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2LKKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:30:11 -0500
MIME-Version: 1.0
In-Reply-To: <50C65AC6.9050904@oracle.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
	<CA+1xoqfu=hw--46Ae+VrP8Xt7Rdozv5TtPvGvhcJr94VVmJQ_A@mail.gmail.com>
	<CA+1xoqdtvq7WQf_1EoGjBo9Rjd1YHS4eSqQX2o-nnYNoMuCzzg@mail.gmail.com>
	<CANN689Gy3nLBasBea-nqkK7zTC4XuhUKH=FmOTcq_pKWPi_xmw@mail.gmail.com>
	<50C65AC6.9050904@oracle.com>
Date: Tue, 11 Dec 2012 12:30:09 +0200
X-Google-Sender-Auth: mMG4966uRU3ByxLirmArnMFqJiU
Message-ID: <CAOJsxLFNYgkNnoqNGe010_1qY80BxXEZEsfkOKvgLD167nMLkA@mail.gmail.com>
Subject: Re: [PATCH 0/3] remove kvm's use of augmented rbtree
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asias He <asias.hejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:57 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 12/10/2012 04:50 PM, Michel Lespinasse wrote:
>> On Mon, Dec 10, 2012 at 8:22 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>> Ping?
>>
>> Hey Sasha,
>>
>> There seems to have been some confusion here. After your last message,
>> I expected *you* to take the patches and push them towards kvm tree.
>> But, I guess you were waiting for Pekka's reply first ? Or did you
>> expect me to go push the patches ?
>>
>> If it helps, I could push this through Andrew's -mm tree; however I
>> think it would make the most sense if these could reach linus's tree
>> through a kvm merge rather than through Andrew's -mm...
>
> Ah, no, Pekka is the one taking care of the KVM tools tree, so I'm we're waiting
> for him to take a look at the patches and take them if they look fine to him :)

Applied, thanks guys!
