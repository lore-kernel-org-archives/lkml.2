Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2LFVQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:16:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42290 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2LFVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:16:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-acpi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Date: Thu, 06 Dec 2012 22:21:32 +0100
Message-ID: <13171753.UmBqOitUxr@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121206205956.GF30885@liondog.tnic>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de> <1379710.dtsKnJm3Er@vostro.rjw.lan> <20121206205956.GF30885@liondog.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 06, 2012 09:59:56 PM Borislav Petkov wrote:
> On Thu, Dec 06, 2012 at 09:56:09PM +0100, Rafael J. Wysocki wrote:
> > Boris, is the patch in -mm somewhere?
> 
> It should be under the name: pnpacpi-fix-incorrect-test_alpha-test.patch
> 
> At least this is what Andrew's scripts said.

Found it, thanks!

I put it into the ACPI tree so that Andrew doesn't have to carry it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
