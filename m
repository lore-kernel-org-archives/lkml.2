Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0HNQjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:39:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64672 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab0HNQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=vZleMJEl82oXnqgSLHSg/8/NzgVFxGPASq0Hwlh11QsYjrwz/LsugKqCLfPdHMV27K
         YEOeAHYDDZBvgJ/ShptKUH6FWsDBzKV37PjumNdgNsNORb+NSAIh9Q/+aF20lf6LoEAv
         RxAoUSoXEW7IkydKAySTNQEdYjjY3+7Mmj6l8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 14 Aug 2010 18:39:14 +0200
Message-ID: <AANLkTikMnW2PfMAQdJKtDGPYeqkev7aJiDMUp6CBznm4@mail.gmail.com>
Subject: Re: 2.6.36-git: BUG in highmem_32.c:45 causing scheduling while atomic
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: bonbons@linux-vserver.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like another side-effect of BR #16588 to me?

Can you try the revert-patches attached to [1], re-compile and give feedback?

- Sedat -

[1] https://bugzilla.kernel.org/show_bug.cgi?id=16588
