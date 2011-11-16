Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1KPAes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:34:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55928 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932742Ab1KPAeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:34:46 -0500
Message-ID: <1321403685.21286.25.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Huang Ying <ying.huang@intel.com>,
        William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 16:34:45 -0800
In-Reply-To: <21274.1321403394@turing-police.cc.vt.edu>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop>
	 <21274.1321403394@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 19:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Nov 2011 17:18:03 PST, Joe Perches said:
> 
> > mp_start(&cookie)
> > pr_<level>(fmt, ...);
> > pr_mp_cont(&cookie, fmt, ...);
> > pr_mp_cont(&cookie, fmt "\n", ...);
> > mp_end(&cookie);
> 
> What should happen if buggy code returns before calling mp_end()?

Every pr_cont use gets emitted with a cookie id
which is annoying enough to get the code fixed
rather quickly no? 

