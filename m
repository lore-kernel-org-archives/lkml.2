Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1JKPyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:54:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59778 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1JKPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:54:42 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Input tree moved back to kernel.org
Date: Tue, 11 Oct 2011 08:54:33 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: Linux Input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20111011011224.GA11832@core.coreip.homeip.net> <20111011174014.f9e23daea8f8c8526096131a@canb.auug.org.au>
In-Reply-To: <20111011174014.f9e23daea8f8c8526096131a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110110854.34037.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 10, 2011 11:40:14 PM Stephen Rothwell wrote:
> Hi Dmitry,
> 
> On Mon, 10 Oct 2011 18:12:24 -0700 Dmitry Torokhov 
<dmitry.torokhov@gmail.com> wrote:
> > I have moved input tree back to its original place on kernel.org:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> > 
> > The structure is still the same: 'for-linus' branch for current work
> > and 'next' (same as master) branch for the next merge window. I will
> > try keeping version on github up to date as well.
> > 
> > Stephen, could you please update linux-next once more?
> 
> I will switch back tomorrow.
> 
> > BTW, does anyone know how one can update project description with
> > gitolite?
> 
> echo <description> | ssh gitolite@ra.kernel.org setdesc <repo>

That worked. Thanks Stephen!

-- 
Dmitry
