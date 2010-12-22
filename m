Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0LWBR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:17:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48376 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0LWBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:17:55 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=qK-MKYc896kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vlzxsyFQE-gvVVU6GlAA:9 a=-cUdMWo59YLESl-5mYXwLCI35YkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Valdis.Kletnieks@vt.edu, mat <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
In-Reply-To: <20101222215725.GB5585@elte.hu>
References: <4CE2F914.9070106@free.fr> <24422.1290656467@localhost>
	 <20101126182355.62615dff@mat-laptop> <20101208221951.GO5750@outflux.net>
	 <20101211001857.4c5e0794@mat-laptop> <20101222124019.GG10809@elte.hu>
	 <34428.1293053719@localhost>  <20101222215725.GB5585@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 22 Dec 2010 17:02:26 -0500
Message-ID: <1293055346.22802.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 22:57 +0100, Ingo Molnar wrote:

> It would be nice to see that fix submitted so that it gets into the tree that 
> introduced the bug.
> 
> Steve, Andrew?

Hi Ingo,

Which tree/branch should I base this on? I could do write up formal
patch and push it out.

-- Steve


