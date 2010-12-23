Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0LWPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:01:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0LWPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:01:52 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=qK-MKYc896kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SxOq48OYts_ZQePICrcA:9 a=yHkUmajqfHwMxrjo8DVx3A7HUV0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, mat <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
In-Reply-To: <34428.1293053719@localhost>
References: <4CE2F914.9070106@free.fr> <24422.1290656467@localhost>
	 <20101126182355.62615dff@mat-laptop> <20101208221951.GO5750@outflux.net>
	 <20101211001857.4c5e0794@mat-laptop> <20101222124019.GG10809@elte.hu>
	 <34428.1293053719@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 10:01:48 -0500
Message-ID: <1293116508.22802.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 16:35 -0500, Valdis.Kletnieks@vt.edu wrote:

> Steve Rostedt's patch that moves the setting of the page permissions seems to
> make this patch no longer necessary.  I tripped over this same issue, but the
> version in the latest -mmotm does not need it, as it includes Steve's fix.

Can I add your "Tested-by: ..." to the commit?

Thanks,

-- Steve


