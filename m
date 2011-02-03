Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1BCWRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:17:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1BCWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=pYt57ic8U9KfEB/7QHSh2MUcCxFvRUcszwWxtpmjy3FBGivcjJkZhgw6L71TxGph9Q
         HoEZ1T+nHZ2ya6/C2PdTgIgH1ZlrmJ/q/hhJKGslTH01vaD9JqptJDgw96E83dJm+22l
         QiuOPxYJlUC7KFNYeXkADpf3Z2WHevOMWEjUE=
Date: Thu, 3 Feb 2011 23:16:49 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: zippel@linux-m68k.org, mmarek@suse.cz, rdunlap@xenotime.net,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110203221631.GA29406@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
	rdunlap@xenotime.net, akpm@linux-foundation.org,
	andrea.gelmini@gelma.net
References: <20110201232750.GA30800@ulf>
 <20110203215855.GA29292@ulf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110203215855.GA29292@ulf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 10:58:55PM +0100, Ulf Magnusson wrote:
> On Wed, Feb 02, 2011 at 12:27:52AM +0100, Ulf Magnusson wrote:
> > Hi,
> > 
> > This is the initial release of Kconfiglib: a Python library for
> > scripting, debugging, and extracting information from Kconfig-based
> > configuration systems.  It can be used to programmatically generate a
> > .config when the '*conf' tools are too inflexible, to quickly find out
> > interesting information about a Kconfig configuration such as dependency
> > relations between symbols and where undefined symbols are referenced,
> > and in applications that need to parse and extract information from
> > Kconfig files.
> > 
> > For a much longer introduction including multiple examples, see
> > arch/kconfig/kconfiglib.py.
> > 
> > Have fun!
> > 
> > Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> > ---
> > Convenience links:
> > 
> > Documentation, generated from kconfiglib.py with pydoc -w:
> > http://dl.dropbox.com/u/10406197/kconfiglib.html
> > 
> > Examples as separate files:
> > http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz
> > 
> > 
> > The patch should be preferably be applied to a recent kernel, i.e. Linus's
> > (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
> > kconfigtest.py test suite - which compares output character-for-character -
> > will indicate failure on older (a few months old) kernels versions even though
> > the outputs are functionally equivalent.
> > 
> > [...]
> 
> Seems linux-kbuild and linux-doc won't accept the patch (too large?), so
> here's a link to the message on linux-kernel:
> https://lkml.org/lkml/2011/2/1/439
> 
> /Ulf Magnusson

Oh, and here's the patch message. Apply with 'git am'.
http://dl.dropbox.com/u/10406197/kconfiglib
