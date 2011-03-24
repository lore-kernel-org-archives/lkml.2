Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab1CXRHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:07:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54708 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890Ab1CXRHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FmrcWq2RIGw32RLGLQhuCoNlqxdMgNXKthlKkZqX0mdTyeExQ9VfnKxJnELz0pkLy1
         SVRu8q0KFIFrprUKcIitO2xi7ggbs39t4j5IPQ1yIEvr2EHy6yY61DLoQtqykb8I4bSK
         QrjPzPzgBOTaUVdMphaDZbPIfi3T+PrI2Guts=
MIME-Version: 1.0
In-Reply-To: <20110324161446.GA32068@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<20110324160310.GA27127@elte.hu>
	<20110324161446.GA32068@elte.hu>
Date: Thu, 24 Mar 2011 19:07:43 +0200
X-Google-Sender-Auth: Btn3y62OUR7cKMZxXa3Bh-6QTJM
Message-ID: <AANLkTimppcCuKYPQjRhEhRyRUNZ06NxZ_SMVYhem3ur2@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 6:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> The combo revert below solves the boot crash.
>
> Thanks,
>
>        Ingo
>
> ------------------------------->
> From 1b322eee05a96e8395b62e04a3d1f10fb483c259 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 24 Mar 2011 17:03:51 +0100
> Subject: [PATCH] Revert various slub patches
>
> Revert "slub: Add missing irq restore for the OOM path"
>
> This reverts commit 2fd66c517d5e98de2528d86e0e62f5069ff99f59.
>
> Revert "slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case"
>
> This reverts commit a24c5a0ea902bcda348f086bd909cc2d6e305bf8.
>
> Revert "slub,rcu: don't assume the size of struct rcu_head"
>
> This reverts commit da9a638c6f8fc0633fa94a334f1c053f5e307177.

Btw, this RCU commit is unrelated. It just happens to have a merge
conflict with the lockless patches which is why you needed to revert
it.

                        Pekka
