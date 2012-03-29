Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab2C2XFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:05:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37079 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab2C2XFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:05:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120329225429.GA25320@redhat.com>
References: <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com> <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com> <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com> <20120329214510.GD13970@thunk.org>
 <20120329214959.GA20783@redhat.com> <CA+55aFz5Di6K4TzrFrGdyrPQkadt1pkGrWv_9GyaVgUjx_4cwg@mail.gmail.com>
 <20120329225429.GA25320@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 16:04:50 -0700
X-Google-Sender-Auth: Mdnb3IX54XPO13PoTYT79jNqSis
Message-ID: <CA+55aFxwfzRniiTRVysvjnSaMYXQwrk8O8iQ-xdy1DXYxeL+cw@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Ted Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 3:54 PM, Dave Jones <davej@redhat.com> wrote:
>
> 90 mins of 2x kernel builds in parallel along with
> 3x fsx runs. then my battery ran out.
>
> looks like we have a winner.

Ok, let's revert it. Do you want to write the description of what
happened, or should I just do it?

                  Linus
