Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1EXRla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:41:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab1EXRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <4DDBEC91.8020004@zytor.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
 <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
 <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com>
 <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com> <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
 <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com> <alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>
 <BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com> <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
 <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com> <4DDBEC91.8020004@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 10:41:04 -0700
Message-ID: <BANLkTimGGukCD_eLfCTXWjbiz=7ucEwj7Q@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-arch@vger.kernel.org,
        linux-mm <linux-mm@kvack.medozas.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:36 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I think this whole discussion misses the essence of the new development
> model, which is that we no longer do these kinds of feature-based major
> milestones.

Indeed.

It's not about features. It hasn't been about features for forever.

So a renumbering would be purely about dropping the numbers to
something smaller and more easily recognized. The ABI wouldn't change.
The API wouldn't change. There wouldn't be any big "because we finally
did xyz".

                        Linus
