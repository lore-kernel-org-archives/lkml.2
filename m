Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1JNW0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:26:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44126 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab1JNW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:26:47 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20111013233818.GB26654@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 17:26:44 -0500
Message-ID: <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 01:38 +0200, Andi Kleen wrote:
> Stephen,
> 
> Please include 
> git://github.com/andikleen/linux-misc.git const-sections
> in linux-next. This has a tree sweep to fix all kind of constant 
> section issues.
> 
> I intend to send Linus a pull request next cycle and would like 
> to get some testing in next first.
> 
> I got various acks last time it was posted and added them all.
> In general it falls more in the "trivial" category, but it's 
> rather large and all over so I may have made a mistake.

It's not incredibly trivial: it causes a compile failure on parisc:

mm/percpu.c:1372: error: __setup_str_percpu_alloc_setup causes a section
type conflict
make[1]: *** [mm/percpu.o] Error 1

I have no idea why, though.

James


