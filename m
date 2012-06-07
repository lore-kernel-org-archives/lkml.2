Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab2FGNi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:38:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42452 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760522Ab2FGNi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:38:28 -0400
Date: Thu, 7 Jun 2012 15:38:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: bing deng <deng8bing@gmail.com>
Cc: shuox.liu@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v7 1/2] printk: add interface for disabling recursion
 check
Message-ID: <20120607133823.GA5053@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	bing deng <deng8bing@gmail.com>, shuox.liu@intel.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20120605081448.GA7097@liondog.tnic>
 <4FCDD72A.9030701@intel.com>
 <4FCDD78A.3070106@intel.com>
 <20120605151542.GA10669@x1.osrc.amd.com>
 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
 <4FCF155B.3090705@intel.com>
 <4FCF160D.8010404@intel.com>
 <20120606152238.GA3874@x1.osrc.amd.com>
 <4FD01896.1010506@intel.com>
 <CAO6yerJVKgjHe9LBL1ZfcMUzqHA5iZwSf2La+hf19QBDEQ-L0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO6yerJVKgjHe9LBL1ZfcMUzqHA5iZwSf2La+hf19QBDEQ-L0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 01:19:16PM +0000, bing deng wrote:
> Should the two function be export by EXPORT_SYMBOL? The the other
> module can use it.

Not needed right now - functions are only used in built-in code and not
in modules.

-- 
Regards/Gruss,
Boris.
