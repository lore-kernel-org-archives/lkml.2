Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2AKDVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:21:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34753 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2AKDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:21:41 -0500
MIME-Version: 1.0
In-Reply-To: <7vehv77xeq.fsf@alter.siamese.dyndns.org>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <7vmx9v7z1r.fsf@alter.siamese.dyndns.org> <CA+55aFx5NATrpLnkMiV2vAxSAJPK7wkY2vyHbyeZGgT9+jP06w@mail.gmail.com>
 <7vehv77xeq.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 19:21:19 -0800
X-Google-Sender-Auth: fv2293NqqgYFjTr-PROYSfIG5F4
Message-ID: <CA+55aFwuyjDsRogEugTRnzSGHpO231MkZ9YYNpTTxNSgsfBVrg@mail.gmail.com>
Subject: Re: Regulator updates for 3.3
To: Junio C Hamano <gitster@pobox.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 7:03 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> I dunno. You just scrapped the plan for 1.7.10; it may have to be called 2.0
> instead.

Btw, version numbers are cheap. I already argued for updating to 2.0
just because of the new signed tag pulling, which I think is a much
bigger issue.

I don't think a small change like "start the editor by default for
merge messages" is nearly as worthy of a version number. But I
wouldn't argue against it either, exactly because those major numbers
are cheap.

It took the kernel until 2.6.39 to learn that, I think git could learn
to use its major number more freely much earlier.

                   Linus
