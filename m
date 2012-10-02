Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab2JBCee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:34:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41616 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2JBCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwoDOdKv9wcqEPkE76+w2TCz+419qp94T3_70jK9dR3-A@mail.gmail.com>
References: <1349135827-24790-1-git-send-email-olof@lixom.net> <CA+55aFwoDOdKv9wcqEPkE76+w2TCz+419qp94T3_70jK9dR3-A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Oct 2012 19:26:26 -0700
X-Google-Sender-Auth: J25wYF3GYVW2LxfdFM4dpGC1GEI
Message-ID: <CA+55aFzmm=y85k81kAfgiuBb=oaFxi0f83hFb32Y2tTHu1wozw@mail.gmail.com>
Subject: Re: [GIT PULL 0/12] ARM: soc: updates for 3.7, first batch
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 7:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, I've merged them all. As usual, my end result is slightly
> different from yours, although the differences are pretty small.

Oh, one more thing: I suspect the OMAP_OCP2SCP config option should
depend on CONFIG_ARM or something. Just based on the name, I assume it
doesn't actually work on x86-64, but I see the question..

               Linus
