Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2DHJA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 05:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2DHJAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 05:00:24 -0400
Message-ID: <4F81539C.3060205@redhat.com>
Date: Sun, 08 Apr 2012 12:00:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] KVM fixes for 3.4-rc1
References: <4F7DCAE0.6010605@redhat.com> <CA+55aFwpzogEZuh+5jP2nLpyiktDu4DTNBC0n-OkzBhcwB38Xg@mail.gmail.com>
In-Reply-To: <CA+55aFwpzogEZuh+5jP2nLpyiktDu4DTNBC0n-OkzBhcwB38Xg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 07:55 PM, Linus Torvalds wrote:
> On Thu, Apr 5, 2012 at 9:40 AM, Avi Kivity <avi@redhat.com> wrote:
> > Linus, please pull a few fixes from
> >
> >  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.4
> >
> > A bunch of powerpc KVM fixes, a guest and a host RCU fix (unrelated),
> > and a small build fix.
>
> Grr.
>
>    static inline int pull_function(void)
>     {
>         return -ENODIFFSTAT;
>     }
>
> Please use the proper scripting to do pull requests, like "git request-pull"
>

I did, but I left the diffstat out accidentally, sorry.

-- 
error compiling committee.c: too many arguments to function

