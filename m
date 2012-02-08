Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2BHMrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:47:22 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43050 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111Ab2BHMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:47:20 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Keith Packard <keithp@keithp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1326708966.3629.31.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
	 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
	 <8639cqjvyn.fsf@sumi.keithp.com>
	 <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
	 <86sjkpiw8i.fsf@sumi.keithp.com>
	 <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120116093133.GB15333@elte.hu>
	 <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120116095529.GA838@elte.hu>
	 <1326708966.3629.31.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Feb 2012 12:46:49 +0000
Message-ID: <1328705209.3718.1.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 10:16 +0000, Matt Fleming wrote:
> On Mon, 2012-01-16 at 10:55 +0100, Ingo Molnar wrote:
> > Does your new patch apply cleanly on top of the revert? If not 
> > then please send an updated one, so that we can investigate its 
> > effects.
> 
> Good point, it doesn't apply cleanly. Here's an updated version rebased
> against Linus' tree.

Ping? Keith, have you had chance to test this patch yet?

-- 
Matt Fleming, Intel Open Source Technology Center

