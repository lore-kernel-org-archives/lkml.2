Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1EXHoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:44:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65392 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1EXHoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BrFJGfVsn7El5jmKEaOOmgWzETy2uhGHPZyOPh1xeqwUFXQUc6nMRIIgm3fW42uamd
         xhXzmyA8qQBf0Z5PBnLFWrILhJOVBMuhRN7+YXthSRILidjg0Hy9czNAHwZ11uO4nzYj
         ndDy2DtmPQJIUxCeBantvEMCAod9nrEwHofO8=
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20110524074020.GA9490@flint.arm.linux.org.uk>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523113709.4357b4ba.randy.dunlap@oracle.com>
	 <1306216431.2785.46.camel@localhost> <1306216683.2785.47.camel@localhost>
	 <20110524074020.GA9490@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 10:40:34 +0300
Message-ID: <1306222834.2785.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 08:40 +0100, Russell King wrote:
> On Tue, May 24, 2011 at 08:58:03AM +0300, Artem Bityutskiy wrote:
> > On Tue, 2011-05-24 at 08:53 +0300, Artem Bityutskiy wrote:
> > > On Mon, 2011-05-23 at 11:37 -0700, Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Fix build warnings in physmap.h:
> > > > 
> > > > include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
> > > > include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
> > > > include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
> > > > include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list
> > > > 
> > > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Oh, this was missed during review.  This was introduced in
> > > b7281ca2a4b00044c60c25059f467d05772cdbe3 which is going in via Russel's
> > > tree, so I guess Russel could pick up your patch.
> > 
> > My big apologies, s/Russel/Russell/.
> 
> Which patch?  Neither of these messages contained Randy's patch and I
> wasn't included on the original posting.

Sorry, I assumed you'd look that lkml is in CC and would find it in lkml
(I assumed you are subscribed there). I'll send this patch shortly.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

