Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0IXMc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:32:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42892 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0IXMc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iW+GUiQ57qM/+OWuARHYy7mM1/0kGbjO9Gq9JY68L5z4x1pbhgxXWZhx+oSeKajnSj
         8fewVSo84RIhTZdz/v+6pvWC+Y+ziz5hWy25zt9bzSupIPoPbXRbwhDJj5/A0v0MCeYg
         wd5vpi9w9qGT7J0rHvLNf9fTWuTtiiGrugCuE=
Date: Fri, 24 Sep 2010 14:32:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning from Linus' tree
Message-ID: <20100924123215.GA5368@nowhere>
References: <20100924140859.038ccf89.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924140859.038ccf89.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 02:08:59PM +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> Today's (and lots before) linux-next build (i386 defconfig) produced this
> warning:
> 
> fs/autofs4/root.c:31: warning: 'autofs4_root_compat_ioctl' declared 'static' but never defined
> 
> Introduced by commit c9243f5bdd6637b2bb7dc254b54d9edf957ef17e
> ("autofs/autofs4: Move compat_ioctl handling into fs").


Yeah, I've seen two patches:

autofs: only declare function when CONFIG_COMPAT is defined
autofs4: fix compilation warning

I'm going to relay them. Thanks!

