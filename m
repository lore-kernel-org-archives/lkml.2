Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010Ab0JSNRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:17:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab0JSNRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:17:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Date: Tue, 19 Oct 2010 15:18:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Daniel Walker <dwalker@fifo99.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <alpine.LFD.2.00.1010181833440.2764@xanadu.home> <1287442418.5376.38.camel@Joe-Laptop>
In-Reply-To: <1287442418.5376.38.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191518.04147.arnd@arndb.de>
X-Provags-ID: V02:K0:Smz9yJtVFYJHBWvQC4X+VJOW5CIHAJTqsz5DyXXZnga
 1k257a1glkSVPkvXzjKV1jXh3HkX6A+YNeqcV3Gcz6gS01VxvN
 ZyEpX6CCBcjVkeADaIrTibiT3cHvQ7eT2K8Mc8nAv5p/X2erq8
 g+9gCfssDFGk4fXZXPudwy0KxnKEwDooSm5p2MxFXMq5wYNk0Z
 xP/lG0IiTPDdbOJ++WaXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010, Joe Perches wrote:
> This could have been done:
> 
> $ git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl --nogit | wc -l
> 35
> 
> Even then, using 35 CCs is generally silly.
> 
> It might make some sense for a cover letter and a
> patch series where the series made tree-wide changes
> in multiple directories.

Probably not even then: When a single mail header gets too long, you usually land
in some spam filter and get hate mail from the list owners. The lkml limit is 1024
characters (this may come from an official RFC, don't know), which is usually less
than 35 recipients.

	Arnd
