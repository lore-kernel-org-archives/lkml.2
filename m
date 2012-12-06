Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2LFVXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:23:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39310 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab2LFVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:23:11 -0500
Date: Thu, 6 Dec 2012 22:20:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121206212024.GG30885@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
	linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <1379710.dtsKnJm3Er@vostro.rjw.lan>
 <20121206205956.GF30885@liondog.tnic>
 <13171753.UmBqOitUxr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13171753.UmBqOitUxr@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 10:21:32PM +0100, Rafael J. Wysocki wrote:
> On Thursday, December 06, 2012 09:59:56 PM Borislav Petkov wrote:
> > On Thu, Dec 06, 2012 at 09:56:09PM +0100, Rafael J. Wysocki wrote:
> > > Boris, is the patch in -mm somewhere?
> > 
> > It should be under the name: pnpacpi-fix-incorrect-test_alpha-test.patch
> > 
> > At least this is what Andrew's scripts said.
> 
> Found it, thanks!
> 
> I put it into the ACPI tree so that Andrew doesn't have to carry it.

Ok, CCed so that he can take it out.

-- 
Regards/Gruss,
    Boris.
