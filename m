Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2FEIO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:14:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37485 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2FEIOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:14:54 -0400
Date: Tue, 5 Jun 2012 10:14:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120605081448.GA7097@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20120524061145.GA18284@liondog.tnic>
 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
 <4FBF3295.7090608@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
 <1338165058.14538.209.camel@ymzhang.sh.intel.com>
 <4FC2E8CF.2040109@intel.com>
 <4FC2E944.6060903@intel.com>
 <20120604171202.GA8533@x1.osrc.amd.com>
 <1338856360.14538.220.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1338856360.14538.220.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 08:32:40AM +0800, Yanmin Zhang wrote:
> You are seeing an old patch. The new patches V4 are:
> https://lkml.org/lkml/2012/6/3/176
> https://lkml.org/lkml/2012/6/3/177
> 
> The new patches change mce_panic instead of do_machine_check.

Ok.

> > Also, this commit message above needs more explanation why we want to
> > disable the recursion check on an MCE, maybe an example...
> V4 doesn't have the comment. We would add it in V5.

Cool, thanks.

-- 
Regards/Gruss,
    Boris.
