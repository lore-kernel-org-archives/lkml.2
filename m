Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2IRMNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:13:10 -0400
Received: from antcom.de ([188.40.178.216]:53622 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab2IRMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:13:09 -0400
Message-ID: <50586551.5020404@antcom.de>
Date: Tue, 18 Sep 2012 14:13:05 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        spi mailing list <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 09/19] ARM: ux500: Enable SSP (SPI) for HREF when booting
 Device Tree
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <1347016499-29354-10-git-send-email-lee.jones@linaro.org> <CACRpkdaC_enpxUFNM_wteAQWKER_naUNUH-s1pJtiGzVFSV+og@mail.gmail.com> <505757D8.8090405@antcom.de> <CACRpkdZLdernphVSfwHS43HptS+33=PzorihQ0bBKm689u_oFw@mail.gmail.com>
In-Reply-To: <CACRpkdZLdernphVSfwHS43HptS+33=PzorihQ0bBKm689u_oFw@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/18/2012 02:08 PM, Linus Walleij wrote:
>> When we have sorted out this driver change (please check the new pl022
>> specific dt property names!), I will provide patches for arm-soc to
>> actually use this new interface via dts files.
> 
> OK cool I guess you will do this for the LPC32xx? Or are you testing
> this on some other platforms?

LPC32xx for now. The new code is backwards compatible, so I'd prefer for
others to adopt and test it on their platforms individually before
patching everything at once without testing.

Roland
