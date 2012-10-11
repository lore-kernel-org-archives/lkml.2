Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab2JKXEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:04:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34866 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2JKXEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:04:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
	<CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
Date: Thu, 11 Oct 2012 16:04:44 -0700
X-Google-Sender-Auth: pmbN9i83elwI3ZBdVGHjoXMpTRM
Message-ID: <CAE9FiQW16wue+C96wxeTCUjGYTo7QN3mXKFfgOt8kY0zgnG4JA@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Oct 10, 2012 at 9:40 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
>>
>> So you are missing the Xen patches entirely in this iteration of the
>> series?
>
> please check updated for-x86-mm branch.
>
> [PATCH -v4 00/15] x86: Use BRK to pre mapping page table to make xen happy
>
> could be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-x86-mm

Stefano,

Can you try -v4 to see if xen works with the changes?

Thanks

Yinghai
