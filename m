Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0LMHPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:15:49 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53951 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0LMHPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FRDw3fDqRGPwER6SrEeNsajNzyzpC0WhA71v+ptqKySoYKZgEmbgfVOFDoVQB7/8ZM
         PX9shUi2Nhb8EiLJsTyrO5arf84Zy/13RAYBDlh5b3At98hak1RWFKdkR81ivz/KkqKy
         xoODh69p3cOmMXo9WQbdmhqwJUV71GqnK8XZ4=
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at
In-Reply-To: <20101212140727.GI19897@game.jcrosoft.org>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
	 <20101212005048.GH19897@game.jcrosoft.org>
	 <1292135848.2456.19.camel@homepc>
	 <20101212140727.GI19897@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 10:15:40 +0300
Message-ID: <1292224540.4117.16.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Christophe,

> sorry as I explain before if you have exclusive option you need to create
> kconfig options which are board specific to manage them
> we work to reduce the number of defconfig in the mainline
> and it's not PortuxG20 and Stamp9g20 specific but to have only one defconfig
> for all 9g20 at a first step and late for all sam9

Thank you for time spent on my patches and e-mails!
I was think to do it this way, but unsure that this is a right way.
Now, with yours help, I know what to do.

> > > your patch contain a lots of whitespace please fix it
> > 
> > There is no problems with whitespace. This patch checked by
> > scripts/checkpatch.pl twice. It seems your mailer corrupt this patch.
> my mailer no way mutt does not do it
> and when I edit with vim I saw the whitespace too
> please check again

I found this whitespaces. There is something strange inside of gedit,
because I does not have practice to use spaces for formatting.
It seems, time to learn vi, come :-)

> > Please, use more testimony why it is required to use system_rev here.
> > Yours position does not clear for me.
> > You can point me to the right documentation or discussion about this
> > requirements in the mail archives...
> two bards with the same machine id NACK as we can not compile them in the same
> kernel and this a target we all work on to allow
> if you want to tuse the same machine id as I did for other boards you must use
> system_rev or any detection to identify tehm

OK. I will use the GSIA18S machine instead of the STAMP9G20.
The GSIA18S already registerd in the ARM machines database.

Best regards!
--
Igor Plyatov

