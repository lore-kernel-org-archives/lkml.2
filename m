Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2HPSex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:34:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48737 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2HPSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:34:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120814141513.GA17776@phenom.dumpdata.com>
References: <20120814141513.GA17776@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Aug 2012 11:34:28 -0700
X-Google-Sender-Auth: WMU70QQkMAYIuuSycLT4zGl4mk4
Message-ID: <CA+55aFzDNMNKvibE9ddoUUHp1e3nkti4G3Bj1ummG2XRX49T6g@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.6-rc1-tag
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 7:15 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
>  arch/x86/xen/p2m.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>
> Konrad Rzeszutek Wilk (1):
>       xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.

There's something wrong with your statistics generation. You have done
the diff the wrong way around, and show 5 deletions, when there are
actually 5 insertions.

Please fix your script.

              Linus
