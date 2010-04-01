Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0DAIGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:06:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45590 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0DAIGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MAbdZZuoJHk/ClwoWpVo0t2fazUYE3sPkS5O1qDfaKMLdFgb2lCpB0jsZDvEoBC+Sj
         iuFozrENiM2yOMB3OFPEC/tdyGKo1BMrCdL3Uy1TcQ34kUaBc4TK6Ifhqzeih9ABMvkl
         2wjoFEmKqm9A5cerKNfqEqXrbpl6hqTDZfYKw=
Date: Thu, 1 Apr 2010 11:06:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
Message-ID: <20100401090608.GD5207@nowhere>
References: <20100329212839.GA12254@nowhere> <20100329.150253.11262563.davem@davemloft.net> <20100329222132.GB12254@nowhere> <20100329.153208.190256896.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329.153208.190256896.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 03:32:08PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Tue, 30 Mar 2010 00:21:34 +0200
> 
> > $ ldd /usr/bin/as
> > 	libopcodes-2.18.0.20080103.so => /usr/lib/libopcodes-2.18.0.20080103.so (0xf7ec4000)
> > 	libbfd-2.18.0.20080103.so => /usr/lib/libbfd-2.18.0.20080103.so (0xf7e14000)
> > 	libc.so.6 => /lib/libc.so.6 (0xf7ca0000)
> > 	/lib/ld-linux.so.2 (0xf7efc000)
> 
> Ok, same here.
> 
> > The last kernel I know that don't have such problems is 2.6.31-rc6
> > May be I should bisect?
> 
> Hmmm, since you know a good and bad point, yes a bisect
> might be the best way to proceed here.
> 
> It might be quicker if you first test 2.6.32 and 2.6.33
> and then use the results of that to guide your bisect.
> 
> Anyways, if you narrow it down to a commit I should be
> able to fix this quickly.
> 
> Thanks!


I actually can't. It works well on a backup 2.6.31-rc6 kernel
but when I build a new one of this same version, the problem
happens again. And I don't have the config of the one that works
(and no /proc/config.gz as well).

So I suspect this is something that happens with some specific
configs only.

Anyway, once I get more clues about this, I'll tell you.

Thanks.

