Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0LLTw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:52:59 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:37499 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0LLTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aZPHzS2nxmDqGD3PkiVmNRIgtSgCj/dCjXFrIbfKBW+pPG+Cp3okQy2uueZYQQ2shd
         0PdOd546TBhGx2XP8+1REzNrldOxRcc1J16TFd0KGEqHWhW0ZMccsmiCng6TAx9QwFAy
         SM/C6elLRZL/dYgJMppvSb0GWiwRzBiF4WpzY=
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, costa.antonior@gmail.com,
        ryan@bluewatersys.com, christian.glindkamp@taskit.de,
        pgsellmann@portner-elektronik.at
In-Reply-To: <20101212142200.GG8665@n2100.arm.linux.org.uk>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
	 <20101212005048.GH19897@game.jcrosoft.org>
	 <1292135848.2456.19.camel@homepc>
	 <20101212140727.GI19897@game.jcrosoft.org>
	 <20101212142200.GG8665@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 22:52:50 +0300
Message-ID: <1292183570.8737.33.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

> On Sun, Dec 12, 2010 at 03:07:27PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 09:37 Sun 12 Dec     , Igor Plyatov wrote:
> > > Dear Jean-Christophe,
> > > 
> > > > On 20:00 Fri 10 Dec     , Igor Plyatov wrote:
> > > > > +/*
> > > > > + * Up to date linux/arch/arm/tools/mach-types database required to support this.
> 
> Please wrap comments.

This comment exactly 80 characters long, but anyway I will split it into
two strings in next version of this patch.

> > > > > +MACHINE_START(GSIA18S, "GS_IA18_S")
> > > > > +*/
> > > > > +MACHINE_START(STAMP9G20, "GS_IA18_S")
> > > > if you do this you must use system_rev to identify the board
> > > 
> > > I can cite Christian Glindkamp:
> > > "And for different carrier boards, system_rev does not make sense at
> > > all."
> > > 
> > > Please, use more testimony why it is required to use system_rev here.
> > > Yours position does not clear for me.
> > > You can point me to the right documentation or discussion about this
> > > requirements in the mail archives...
> >
> > two bards with the same machine id NACK as we can not compile them in the same
> > kernel and this a target we all work on to allow
> > if you want to tuse the same machine id as I did for other boards you must use
> > system_rev or any detection to identify tehm
> 
> Well, the platform was registered into the machine database on 10th
> December, so it's missed my recent update to the file queued for the next
> -rc.

Just to clarify: my gsia18s machine number will be added into
linux-2.6.37-rc6?

Does this mean that I must wait for rc6 and then send my patch with new
machine name or I can send it now?

> I also notice that the name has been changed - machine_is_gsia18s() vs
> MACH_TYPE_GS_IA18_S / CONFIG_MACH_GS_IA18_S.  This means I'll simply
> delete it from any future updates until someone talks to me about fixing
> the entry, exactly as I'm doing with a bunch of others who also haven't
> contacted me.
> 
> All it takes is an email and the entry gets quickly fixed...

Russel, please fix it to more readable "gsia18s" and "*_GSIA18S" for my
3234 machine.
Old names with two underscores ("gs_ia18_s" and "*_GS_IA18_S") was very
hard to read in the source code.

Best regards!
--
Igor Plyatov

