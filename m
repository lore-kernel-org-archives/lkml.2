Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0JZPJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:09:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745Ab0JZPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinUMzMZEredesCH-qr-WBVPmNT+HGOq8T5ikd_G@mail.gmail.com>
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org> <4CC6CD4D.3010501@kernel.org>
 <20101026132548.GA14666@elte.hu> <4CC6D8FD.10802@kernel.org> <AANLkTinUMzMZEredesCH-qr-WBVPmNT+HGOq8T5ikd_G@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Oct 2010 08:08:56 -0700
Message-ID: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
Subject: Re: [PATCH] x86, percpu: revert commit fe8e0c25
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 6:49 AM, Brian Gerst <brgerst@gmail.com> wrote:
>
> Probably the best fix is to go back to allocating the stacks with
> get_free_pages(), and only keep the pointers in percpu memory.

Yes, please do. The "irq stack in percpu area" upsides are almost zero
afaik, and the complexity required for it has been ridiculous.

                                 Linus
