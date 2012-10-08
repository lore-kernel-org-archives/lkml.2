Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2JHRuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:50:20 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60941 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab2JHRuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <1349714729.15966.167.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
	<1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
	<CACx33ghsnYz0VNwEbhuyn7ZgrtamHfrTKHR4E0b9Q+LpahcDXw@mail.gmail.com>
	<1349714729.15966.167.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Mon, 8 Oct 2012 23:50:16 +0600
Message-ID: <CACx33gg7M7WNFrFg47WX17HZvD-H6mW8_w5y8d16K-uMfUa_kQ@mail.gmail.com>
Subject: Re: boot failure on i7-3317u in Samsung 900x3c
From: Mike Bakhterev <mike.bakhterev@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 10:45 PM, Matt Fleming <matt@console-pimps.org> wrote:
> mcelog should be able to parse your MCE codes.
>
> --
> Matt Fleming, Intel Open Source Technology Center
>

mcelog --ascii says:

echo -e 'CPU 3: Machine Check Exception: 5 Bank 6:
be2000000003110a\nTSC 2a124d1ca ADDR fe400 MISC f880004086' | mcelog
--ascii
CPU 3: Machine Check Exception: 5 Bank 6: be2000000003110a
TSC 2a124d1ca ADDR fe400 MISC f880004086
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 3 BANK 6 TSC 2a124d1ca
MISC f880004086 ADDR fe400
STATUS be2000000003110a MCGSTATUS 5
