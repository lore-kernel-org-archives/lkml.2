Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1FUXf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:35:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1FUXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=gkixB4/dT8PQ41u43c1nMHyh1rYnabSn9tor/bNt+FoOKLaHSrtLcM+4lmnScjUjXs
         HNbQK6FhVdM62yV1A8EfxMgbvTO4LyJQmQzxbZKEsDLB5WVqsH1LYRSazlqLw7jy0oBQ
         LnWPrFsaINwLiTfwhJOVLbzORhW/6XTr4lnY8=
MIME-Version: 1.0
In-Reply-To: <20110621160528.7c92cff0.akpm@linux-foundation.org>
References: <1308347614-402-1-git-send-email-vapier@gentoo.org>
 <1308347614-402-7-git-send-email-vapier@gentoo.org> <20110621160528.7c92cff0.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 21 Jun 2011 19:35:35 -0400
X-Google-Sender-Auth: YpqalVCAVV1vZpPFLujsEwmPaVI
Message-ID: <BANLkTi=y8JcdoS94MV2=gYrBa66vrzU_4Q@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 6/6] Blackfin: SMP: convert to common asm-generic/atomic.h
To: Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 19:05, Andrew Morton wrote:
> On Fri, 17 Jun 2011 17:53:34 -0400 Mike Frysinger wrote:
>> Now that common code supports SMP systems, switch our SMP atomic logic
>> over to it to avoid code duplication.
>
> There were some rejects on this one, I think because lines 2, 3 and 4
> had non-ascii crap in them and because your patch was expecting
> inclusions of asm-generic/atomic-long.h and asm-generic/atomic64.h,
> which were removed.

in the patch summary, i mentioned that the Blackfin ones are informational only:
> The 2 Blackfin patches are just to show what's going on; I can
> merge them through my tree like normal.  But the asm-generic
> ones will have to be picked up by Andrew.

so dont pick the Blackfin ones up ;)
-mike
