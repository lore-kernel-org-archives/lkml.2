Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1GZS2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:28:32 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54265 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751443Ab1GZS21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:28:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PNyRTbgJhlB3K5C4MwuY7yTVAYXk2R5Go6KtDIHIDN3KJPpE+vJy80iNjxhl1UdwkANQmTn3nqHdH5Jzz1PkOEmJDIGT0NS/rZqP8SiUkYFxWbMTDRRlFva+uwVZbQw5;
Date: Tue, 26 Jul 2011 11:28:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(),
 KCONFIG_BUILTIN() and KCONFIG_MODULE()
Message-Id: <20110726112824.b357c756.rdunlap@xenotime.net>
In-Reply-To: <4E2F0735.1070403@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
	<4E2EBF63.8050208@suse.cz>
	<20110726080443.62196869.rdunlap@xenotime.net>
	<4E2F0735.1070403@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 20:28:05 +0200 Michal Marek wrote:

> Dne 26.7.2011 17:04, Randy Dunlap napsal(a):
> > On Tue, 26 Jul 2011 15:21:39 +0200 Michal Marek wrote:
> >> On 26.7.2011 15:01, Américo Wang wrote:
> >>> BTW, the name KCONFIG(CONFIG_NUMA) seems ugly.
> >>
> >> Suggest a better one :). The proposals so far:
> >> config_is_numa() (breaks grep)
> > 
> > explain, please.
> 
> If you grep for CONFIG_FOO usage, you'll miss this alternate syntax.
> 

Ack.

> 
> >> CONFIGURED(CONFIG_NUMA)
> >> ENABLED(CONFIG_NUMA)
> >> KCONFIG(CONFIG_NUMA)
> > 
> > CONFIG(NUMA) || CONFIG(NUMA_BUILTIN) || CONFIG(NUMA_MODULE)
> 
> same problem.

Yes, I sorta got that after I sent the email.

I guess I prefer your ENABLED() syntax then.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
