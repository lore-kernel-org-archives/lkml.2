Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0IUFYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:24:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34438 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0IUFYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xChYx4I1fP7AI4yZs5m6/ti3/I7W95w1hvyMb3niEUIFM+IcJ2E7FR6Cf6B90GWBE9
         z3ZVdIpYJfDHwx1dko+sFtfqfbHTkzVesLWvpgNraOOQ5VDEezF9TRfszE962/eg8Hg+
         DMLLtR9uZ6+Lont/MD1t/lzx5a26nbQouk7zI=
Date: Mon, 20 Sep 2010 22:24:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Abraham Arce <x0066660@ti.com>, Syed Rafiuddin <rafiuddin.syed@ti.com>
Subject: Re: linux-next: manual merge of the input tree with the davinci tree
Message-ID: <20100921052438.GB5066@core.coreip.homeip.net>
References: <20100921124632.3be46417.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921124632.3be46417.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:46:32PM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> drivers/input/keyboard/Kconfig between commit
> 34dca1011e05d3965c0f60d51a69643789683877 ("input: add driver for
> tnetv107x on-chip keypad controller") from the davinci tree and commit
> a17f79553f052f04d47689a842118f775f81b7e3 ("Input: add support for OMAP4
> keyboard controller") from the input tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

I am afraid you'll have to carry this one till the next merge window -
it seemed that Davinci drivers better be merged through davinci tree so
we'll have this conflict.

Sorry about this.

-- 
Dmitry
