Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2HNPqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:46:21 -0400
Received: from seven.medozas.de ([5.9.24.206]:50584 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2HNPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:46:19 -0400
Date: Tue, 14 Aug 2012 17:46:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: =?UTF-8?Q?Martin-=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
cc: Jonathan Nieder <jrnieder@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] scripts/package/builddeb: upgrade to current practices
In-Reply-To: <CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1208141710580.18667@frira.zrqbmnf.qr>
References: <1342547874.5129.2.camel@henna.lan> <20120717193951.GA15208@burratino> <CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2012-07-17 21:46, Martin-Éric Racine wrote:
>>> @@ -188,17 +188,17 @@ This is a packacked upstream version of the Linux kernel.
>>>  The sources may be found at most Linux ftp sites, including:
>>>  ftp://ftp.kernel.org/pub/linux/kernel
>>>
>>> -Copyright: 1991 - 2009 Linus Torvalds and others.
>>> +Copyright: 1991-2012 Linus Torvalds and others.
>>>
>>> -The git repository for mainline kernel development is at:
>>> -git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>> +The GIT repository for mainline kernel development is at:
>>> +git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>
>> I personally like to spell it as "Git". ;-)
>
>That works for me too. Actually, what's the official spelling for it?

The acronymic usage of "GIT" to mean Global Information Tracker has
not caught on. Therefore most likely "Git"; like "Linux", a noun, a
name.

