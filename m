Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1DGNXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:23:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2135 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab1DGNXF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:23:05 -0400
From: "Boivie, Victor" <Victor.Boivie@sonyericsson.com>
To: Nick Bowler <nbowler@elliptictech.com>,
        =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonyericsson.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Apr 2011 15:22:57 +0200
Subject: RE: [PATCH] ARM: Allow for kernel command line concatenation
Thread-Topic: [PATCH] ARM: Allow for kernel command line concatenation
Thread-Index: Acv1JkfxTg79fbJLRJKuYjmNGg/eyAAABMDQ
Message-ID: <56A05FDF86209947BB88FDF67E6D4A1073F0B973E2@SELDMBX04.corpusers.net>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
 <20110407131810.GA6450@elliptictech.com>
In-Reply-To: <20110407131810.GA6450@elliptictech.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config CMDLINE_EXTEND
> > +	bool "Extend bootloader kernel arguments"
> > +	depends on CMDLINE != ""
> > +	help
> > +	  The default kernel command string will be concatenated with the
> > +	  arguments provided by the boot loader.
> 
> Since concatenation is not commutative, this help text should describe
> exactly the order in which the arguments are concatenated.  How about
> this instead:
> 
>   The command-line arguments provided by the boot loader will be
>   appended to the default kernel command string.

I completely agree. New patch upcoming. Thanks.

Best regards,
Victor Boivie,
Sony Ericsson Mobile Communications AB
