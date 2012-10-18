Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2JRUgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:36:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46680 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2JRUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210181754290.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
	<CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
	<alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
	<20121018162611.GA11556@jshin-Toonie>
	<alpine.DEB.2.02.1210181754290.2689@kaball.uk.xensource.com>
Date: Thu, 18 Oct 2012 13:36:06 -0700
X-Google-Sender-Auth: FFNmn_Lzf_vkwQu1Xkw4NwHEo04
Message-ID: <CAE9FiQX_d46zRMOMUKQMWSqAPgTLqzUiJbqgcyRbCpHnt-NJPw@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 9:57 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> Jacob,
> thanks for testing!
>
> Yinghai, it might be useful for you to try your patch series on Xen.
> It is pretty simple, considering that you only need the hypervisor.
> Just follow these steps:
>
> - clone the xen-unstable git mirror
> git clone git://xenbits.xen.org/xen.git
>
> - compile and install xen
> make xen
> cp xen/xen.gz /boot

yes, i tried dom0 with xen 32bit and 64bit, all can boot well.

but did not test with domU.

Thanks

Yinghai
