Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0KIOfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:35:07 -0500
Received: from smtp02.bis.na.blackberry.com ([216.9.248.49]:26299 "EHLO
	smtp02.bis.na.blackberry.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab0KIOfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:35:04 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 09:35:04 EST
X-rim-org-msg-ref-id: 365183656
Message-ID: <365183656-1289312722-cardhu_decombobulator_blackberry.rim.net-540010530-@bda083.bisx.prod.on.blackberry>
Reply-To: drosenberg@vsecurity.com
X-Priority: Normal
Sensitivity: Normal
Importance: Normal
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
To: "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>
From: "Dan Rosenberg" <drosenberg@vsecurity.com>
Date: Tue, 9 Nov 2010 14:25:21 +0000
Content-Type: text/plain
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA9EZKAh023211

I agree with this.  Unless anyone else has any suggestions, I'll get this ready tonight.

-Dan

------Original Message------
From: Ingo Molnar
To: Arjan van de Ven
Cc: Dan Rosenberg
Cc: linux-kernel@vger.kernel.org
Cc: security@kernel.org
Cc: stable@kernel.org
Cc: Andrew Morton
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Sent: Nov 9, 2010 9:20 AM


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 09 Nov 2010 07:11:12 -0500
> Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > 
> > > 
> > > The initialization to zero is implicit, no need to write it out.
> > > 
> > 
> > I'll resend after the first round of comments.
> > 
> > > Also, it would also be useful to have a
> > > CONFIG_SECURITY_RESTRICT_DMESG=y option introduced by your patch as
> > > well, which flag allows a distro or user to disable unprivileged
> > > syslog reading via the kernel config.
> > 
> > Are you suggesting having the existence of the sysctl depend on 
> > CONFIG_SECURITY_RESTRICT_DMESG, or having a choice between a sysctl (when config 
> > is disabled) and having restrictions always on (when config is enabled)?
> 
> and/or have the sysctl default value depend on the config option

Yeah. I think we should have the sysctl unconditionally as in Dan's current patch - 
and make the default depend on the Kconfig setting (defaulting to off).

I.e. essentially the same as the current patch, just a bit more configurability via 
the Kconfig setting.

Thanks,

	Ingo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
