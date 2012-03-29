Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab2C2UKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:10:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34886 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662Ab2C2UKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120329195354.GA11790@redhat.com>
References: <20120329155542.GA31285@redhat.com> <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com> <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 13:10:21 -0700
X-Google-Sender-Auth: G9jLtUYbe-9SjPv268L2tCp24_0
Message-ID: <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 12:53 PM, Dave Jones <davej@redhat.com> wrote:
>
> sysrq-p looks kinda boring. I couldn't get sysrq-l to coincide
> with kworker running.

Yeah, none of that looks interesting.

Apparently kworker isn't actually using all CPU after all.

                    Linus
