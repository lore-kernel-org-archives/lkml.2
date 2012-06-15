Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab2FOLiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:38:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2FOLiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:38:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: build failure in Linus' tree
Date: Fri, 15 Jun 2012 11:38:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au> <20120614030606.GC27673@linux-sh.org> <20120614034036.GE27673@linux-sh.org>
In-Reply-To: <20120614034036.GE27673@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206151138.01510.arnd@arndb.de>
X-Provags-ID: V02:K0:FkAm4VRCU+pLs5idii36yYJNcjj70XXyqxYmt3hfUYV
 yUJpJiCHfrPjhSOOsagWKjugN0Evauvc3N6BrUZ/grOdhiGRLx
 RF0H4wM23+yxyQydu93kSKZSlMWvhGjftVvxGZxTTV6Tg3eeH2
 C/t9mec1lRsIkLZ/dqZ3aiy/Z6f5buJpyGdNBLUjUzyAML6MEa
 zjj9SWa/x3aLoFMo0MeOGutOVxDzTJmhKZzAZDwT08nZnh13FZ
 0Qgar6mUePtNYJyusnJ+y625RNHkjPZ8LboXqa5YlPPSlsjebu
 598HFBKPdwwQ3Y4OkTOFuhGDXTzcOunxn6T84HIrgQpRftAZ2s
 Df28V67591ZFT/8FjhCA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2012, Paul Mundt wrote:
> Ok, it's because the asm-generic/bug.h __ASSEMBLY__ guarding is
> completely bogus. This should hopefully fix it once and for all.
> Sorry for the trouble.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
