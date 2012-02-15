Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2BOMNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:13:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43847 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab2BOMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:13:04 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>
In-Reply-To: <86d39pfdqd.fsf@sumi.keithp.com>
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
	 <1328705209.3718.1.camel@mfleming-mobl1.ger.corp.intel.com>
	 <86d39pfdqd.fsf@sumi.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 12:13:01 +0000
Message-ID: <1329307981.3675.120.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 09:15 -0800, Keith Packard wrote:
> <#part sign=pgpmime>
> On Wed, 08 Feb 2012 12:46:49 +0000, Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Ping? Keith, have you had chance to test this patch yet?
> 
> No, I haven't had a chance to try the patch, and I'm leaving on vacation
> tomorrow until March 1...

Hmm... I haven't been able to find anybody else willing to test this
patch either.

Ingo, got any opinions on how to handle this?

-- 
Matt Fleming, Intel Open Source Technology Center

