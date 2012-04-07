Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2DGQ4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 12:56:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49190 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2DGQ4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 12:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <4F7DCAE0.6010605@redhat.com>
References: <4F7DCAE0.6010605@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Apr 2012 09:55:40 -0700
X-Google-Sender-Auth: Z389Ea1TbphP4gUCS1wiT7CcDls
Message-ID: <CA+55aFwpzogEZuh+5jP2nLpyiktDu4DTNBC0n-OkzBhcwB38Xg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 3.4-rc1
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 9:40 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull a few fixes from
>
>  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.4
>
> A bunch of powerpc KVM fixes, a guest and a host RCU fix (unrelated),
> and a small build fix.

Grr.

   static inline int pull_function(void)
    {
        return -ENODIFFSTAT;
    }

Please use the proper scripting to do pull requests, like "git request-pull"

                      Linus
