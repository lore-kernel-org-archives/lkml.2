Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2FOMiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:38:05 -0400
Received: from antcom.de ([188.40.178.216]:35462 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab2FOMhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:37:47 -0400
Message-ID: <4FDB2C99.50503@antcom.de>
Date: Fri, 15 Jun 2012 14:37:45 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alexandre Pereira da Silva <aletes.xgr@gmail.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 00/23] ARM: LPC32xx specific updates for next
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <201206151207.07108.arnd@arndb.de> <CAAAP30HU7k2QC9K15V3grZvXDzy8apzBGSo8it+M4KF5wGWLZw@mail.gmail.com>
In-Reply-To: <CAAAP30HU7k2QC9K15V3grZvXDzy8apzBGSo8it+M4KF5wGWLZw@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/15/2012 02:12 PM, Alexandre Pereira da Silva wrote:
> On Fri, Jun 15, 2012 at 9:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> It all looks good from my point of view, so I think we can pull it
>> for 3.6 if no other comments come.
> 
> Arn,
> 
> Please exclude "ARM: LPC32xx: Remove duplicate usb host clock init".
> It's causing problems in some LPC32XX boards.

Right - it would break USB e.g. on the EA3250 board since USB would work
only if the bootloader already did some initialization which is silently
done by PHY3250 where we didn't recognize the problem.

So please just take patches 01..22 from the lpc32xx-next branch.

I just removed patch 23 from git.antcom.de, so you can easily just pull
the branch.

Further, as Russell already pointed out, the DMA API will probably
change, but I expect that we will quickly adjust to it so no need to
worry about that.

Thanks,

Roland
