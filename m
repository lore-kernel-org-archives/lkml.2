Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1BEA24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 19:28:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1BEA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 19:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B0S45e+fS2/cgOwi/w2jdCQdvRJkotjzTqnqgQUg0Kx+QhZvmuceBytAtAdxQ8Icye
         sF71WPIP4Y0AkVwBnK2foso01awoTE7WlH+aF6VS8ruS/XdBextbXViUl5Gl81JY8+PC
         926Dj2hnh8oQeP2d81Hs5JLqFRjl1mUFsbaqg=
MIME-Version: 1.0
In-Reply-To: <4D4C8EFA.40207@landley.net>
References: <20110201232750.GA30800@ulf>
	<20110204143529.f49e92e5.rdunlap@xenotime.net>
	<4D4C8EFA.40207@landley.net>
Date: Sat, 5 Feb 2011 01:28:50 +0100
Message-ID: <AANLkTi=O4C-JRbosVKag-QQiGODbrAznn3=EnoOET6BR@mail.gmail.com>
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python Kconfig parser
From: Filip Honckiewicz <f.honckiewicz@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Ulf Magnusson <ulfalizer.lkml@gmail.com>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, mmarek@suse.cz, akpm@linux-foundation.org,
        andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulf!

I'm working on pretty same thing also in python... Now I'm sad,
because you made it and I don't, and also my code looks like dung in
comparison to yours. How long did you make this?

BTW. "SLOW_WORK" symbol used in drivers/gpu/drm/Kconfig in "menucofnig
DRM" as one of selects isn't an unnecessary symbol? I can't find any
SLOW_WORK entry.

Filip
