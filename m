Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2DUMbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:31:15 -0400
Received: from antcom.de ([188.40.178.216]:49401 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2DUMbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:31:14 -0400
Message-ID: <4F92A88E.1000007@antcom.de>
Date: Sat, 21 Apr 2012 14:31:10 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Defconfig update for LPC32xx
References: <1335006394-26810-1-git-send-email-stigge@antcom.de> <201204211146.29929.arnd@arndb.de>
In-Reply-To: <201204211146.29929.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 21/04/12 13:46, Arnd Bergmann wrote:
> I think the latest version of all of your patches is good, but I've
> lost track of which ones you want to go through arm-soc. Can you send
> me pull requests for each series you want applied on monday if you get
> no more comments?

Yes, I was planning an arm-soc pull request anyway. First concentrating
on the other subsystem's patches and then providing the arm-soc bits in
one go. The other subsystem's patches are not merged completely, yet,
but arm-soc can already merge on monday - pretty stabilized DT
conversion now.

Thanks,

Roland
