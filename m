Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2BHRPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:15:45 -0500
Received: from home.keithp.com ([63.227.221.253]:60106 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2BHRPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:15:44 -0500
From: Keith Packard <keithp@keithp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
In-Reply-To: <1328705209.3718.1.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com> <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com> <86sjkpiw8i.fsf@sumi.keithp.com> <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com> <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com> <20120116093133.GB15333@elte.hu> <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com> <20120116095529.GA838@elte.hu> <1326708966.3629.31.camel@mfleming-mobl1.ger.corp.intel.com> <1328705209.3718.1.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 08 Feb 2012 09:15:38 -0800
Message-ID: <86d39pfdqd.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Wed, 08 Feb 2012 12:46:49 +0000, Matt Fleming <matt@console-pimps.org> wrote:

> Ping? Keith, have you had chance to test this patch yet?

No, I haven't had a chance to try the patch, and I'm leaving on vacation
tomorrow until March 1...

-- 
keith.packard@intel.com
