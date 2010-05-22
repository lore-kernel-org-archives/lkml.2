Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0EVKXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 06:23:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55794 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0EVKXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 06:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EaRYTU9SpFlPz2s4ZJQjqbOnKEdrN4JqoSh0BRnp7JKFEaC293AjhzHDalPlUqd+6i
         ndmHcvP0FsiPb1IfTuUPUh+DWlCGlTmKjA4Qe4TNIXYILfq0uu+vryE1F1Be3eBtJ6zm
         9wh34H0T6Byp05bePrTbPL7TApRHK7kiuWkPk=
MIME-Version: 1.0
In-Reply-To: <HqroMXsT-CJ.A.qYG.f_y5LB@chimera>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
	 <HqroMXsT-CJ.A.qYG.f_y5LB@chimera>
Date: Sat, 22 May 2010 13:22:57 +0300
X-Google-Sender-Auth: mr7PhDQPgBvAmo6wgiPQO50vjT4
Message-ID: <AANLkTikXPfDVhwsUMr5yDpsvgk06QrMFXpG22k8T0ydi@mail.gmail.com>
Subject: Re: [Bug #15601] [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "michael-dev@fami-braun.de"@ogre.sisk.pl,
       David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15601
> Subject         : [BUG] SLOB breaks Crypto
> Submitter       : michael-dev@fami-braun.de
> Date            : 2010-03-15 13:39 (56 days old)
> Message-ID      : <4B9E38AF.70309@fami-braun.de>
> References      : http://marc.info/?l=linux-kernel&m=126866044724539&w=2

Herbert, David, Matt, this bug should be fixed by the following two
commits, right?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=18eb8ea6ee4cc9ed39b45f95b734f523bcfb586b

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=273fca0ecad9305247043815e185d1bfd04047d4
