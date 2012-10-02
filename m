Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2JBRBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:01:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61411 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838Ab2JBRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:01:15 -0400
Date: Tue, 2 Oct 2012 17:58:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Howells <dhowells@redhat.com>
Cc: "torvalds@osdl.org" <torvalds@osdl.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
Message-ID: <20121002165842.GJ25708@arm.com>
References: <CAHkRjk4Nv-Wb6NA9tZkLPQw8NFvTXMScF3x6i=e+KeBC0uF6Dw@mail.gmail.com>
 <15670.1349125526@warthog.procyon.org.uk>
 <30848.1349196911@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30848.1349196911@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:55:11PM +0100, David Howells wrote:
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > There is arm64 that got merged, so its headers need splitting as well.
> > I'm happy to send a pull request myself just for arm64 if you give me
> > the script, otherwise you can run you script again close to -rc1 (and
> > I'll test it).
> 
> I can just re-run my scripts and post a new set of patches.

I'm fine with this.

-- 
Catalin
