Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0IZOxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:53:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0IZOw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:52:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the rr tree
Date: Sun, 26 Sep 2010 16:52:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
References: <20100915132646.4aef58f8.sfr@canb.auug.org.au> <201009161020.01392.arnd@arndb.de> <20100916085608.GB8159@amit-laptop.redhat.com>
In-Reply-To: <20100916085608.GB8159@amit-laptop.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261652.44542.arnd@arndb.de>
X-Provags-ID: V02:K0:vwUcL9aMy+85+SXR2cc+637FDe23OSKKKvqN/+5fwsb
 J87LvaqESrDVi3KS/gxcLqVMKOXBmilkBF9PS1GP9LSY8tpqnE
 H3wBr7vf8U+6893eQJVHdxYz6txuRqYCsXZyGw8ca8RSRob0aM
 ZU0yBabtM+8cfW3HXNE6Kb/bEXqVHge8g1AXIv+DAEUjVkFZ3Z
 XS1xtp7JK98LQ2k678V3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010 10:56:08 Amit Shah wrote:
> On (Thu) Sep 16 2010 [10:20:01], Arnd Bergmann wrote:
> > On Thursday 16 September 2010 08:54:39 Amit Shah wrote:
> > > Arnd, the device is supposed to be non-seekable so I'll add a
> > > nonseekable_open() to the open() call.
> > > 
> > > So I guess the llseek operation should ne no_llseek instead of
> > > noop_llseek.  Will you change that in your patchset?  Should I do that
> > > in the patch I'll queue up?
> > 
> > Yes, I think it's best if you just do both changes in your patch, I'll
> > drop this file from my series then.
> 
> Great, I'll queue that up.

I don't see this change in linux-next yet. What happened?

	Arnd
