Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab2C2VxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:53:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47621 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab2C2VxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120329214959.GA20783@redhat.com>
References: <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com> <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com> <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com> <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com> <20120329214510.GD13970@thunk.org> <20120329214959.GA20783@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 14:52:40 -0700
X-Google-Sender-Auth: QH5fh98600YDQK2CZ0VAPD2RxcQ
Message-ID: <CA+55aFz5Di6K4TzrFrGdyrPQkadt1pkGrWv_9GyaVgUjx_4cwg@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 29, 2012 at 02:45:10PM -0700, Ted Ts'o wrote:
>
>  > > I'll try a build with just that reverted, given the bisect build is taking a while.
>
> up 30 minutes with that reverted, no problems so far..

Goodie. Let it run for a while more, and really pound on it.

Ted, are there any downsides to just reverting that commit (ie any
subtle interactions) for now?  That's assuming that Dave's testing
continues to confirm that it is that one commit.

                    Linus
