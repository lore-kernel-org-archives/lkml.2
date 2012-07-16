Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2GPTpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:45:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2GPTpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:45:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Mon, 16 Jul 2012 19:45:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120715113631.GA10597@arm.com> <20120716161913.GB20549@elf.ucw.cz>
In-Reply-To: <20120716161913.GB20549@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161945.21239.arnd@arndb.de>
X-Provags-ID: V02:K0:3PNKDSdCkxQpBGm5UgJ3Ifen91+aRZ+ecHn/v1zG3jV
 8T3p+dVyyY/YDoyRJgQP+outZ5IM4E0/+Rrrj4K7NDiW7Sb4uE
 bUYBowRDPumXs8o/IUQhx03TbRI1dDP6a2g6Q0r8T97XqkemaN
 RyJu4eQeNPvuJHqpGfO6k6X1ff2EmsT+94mQqsUvldnzn0i4uc
 F4Yciw/1OENOyI+Ylh33axeDen8I3HUWpA0wM5W+qXSGZ545vY
 MRqxtWjo6QwDXH2Cc2OOSdIb3MM1kaMAXeZaVnfEa1gnJqh23U
 kjEtn6BKghNmJ+u2gHqoq4AoKfsCj+bonebaXuPOeSFFA3hTKt
 eN1uQCuTHHldETG8lgCQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2012, Pavel Machek wrote:
> > The assembly syntax is very reasonable already and not far from what we
> > are used to (see the .S files in my kernel patches). The 64-bit
> > instructions are different and that's specified here (apart from the
> > actual bit encoding):
> > 
> > http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html
> 
> "This document is only available in a PDF version to registered ARM
> customers."
> 
> It would be nice to make this public :-(.

Well, at least you can register for free and don't have to prove that you
are an ARM customer (who isn't, after all).

	Arnd
