Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2CaAAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:00:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46685 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2CaAAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:00:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjU5tehTf7+nYQv1_7a=+gGN2hVYUdh1g_BF=WRYj0hgg@mail.gmail.com>
References: <CAOesGMjU5tehTf7+nYQv1_7a=+gGN2hVYUdh1g_BF=WRYj0hgg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 17:00:21 -0700
X-Google-Sender-Auth: XAQtHTzfQ3jepcAwFVu8MXL6sLE
Message-ID: <CA+55aFzeN+m0mWqe6ajBB=cdTNJMF2FgW17_mm_n0BoKokQVRw@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: Two more fixes for merge window fallout
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 4:20 PM, Olof Johansson <olof@lixom.net> wrote:
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Hmm. I *think* you meant to ask me to pull the "fixes-for-linus" tag,
which points at the same commit as the "fixes" branch. No?

You might want to double-check whatever script or workflow you use to
generate these pull requests.

               Linus
