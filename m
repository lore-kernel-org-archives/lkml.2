Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0IBTIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:08:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34318 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab0IBTIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B5SxHeD/XzAu5HWP9/omRYSi/YMEQcpTTjf+sAZgHzugmd7Rxu9EZ/Ac0bwlSKeTXD
         RDIZTqRCCIuOpvMcbbQ4/HH25Sc3sHA84zag6DAFOmbISWJs3zZhiBYaHwEkq5mEK9eD
         o/wsQ4imHt8AaGxWjOlGjILLRUaU1y2A59crY=
MIME-Version: 1.0
In-Reply-To: <tip-9fbaf49c7f717740002d49eee1bbd03d89d8766a@git.kernel.org>
References: <1283010066-20935-5-git-send-email-julia@diku.dk>
	<tip-9fbaf49c7f717740002d49eee1bbd03d89d8766a@git.kernel.org>
Date: Thu, 2 Sep 2010 21:08:30 +0200
Message-ID: <AANLkTi=-7Dq09Svwo9nwYA4xzZx4NJapPigW6SodF6g4@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, kmemcheck: Remove double test
From: Vegard Nossum <vegard.nossum@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
        linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
        tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 August 2010 10:36, tip-bot for Julia Lawall <julia@diku.dk> wrote:
> Commit-ID:  9fbaf49c7f717740002d49eee1bbd03d89d8766a
> Gitweb:     http://git.kernel.org/tip/9fbaf49c7f717740002d49eee1bbd03d89d8766a
> Author:     Julia Lawall <julia@diku.dk>
> AuthorDate: Sat, 28 Aug 2010 17:41:03 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 30 Aug 2010 09:19:28 +0200
>
> x86, kmemcheck: Remove double test
>
> The opcodes 0x2e and 0x3e are tested for in the first Group 2
> line as well.
>
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @expression@
> expression E;
> @@
>
> (
> * E
>  || ... || E
> |
> * E
>  && ... && E
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Vegard Nossum <vegardno@ifi.uio.no>
> LKML-Reference: <1283010066-20935-5-git-send-email-julia@diku.dk>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/kmemcheck/opcode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>

Sorry, was a bit late.

Thanks for the patch, review, and picking up :-)


Vegard
