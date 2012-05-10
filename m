Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2EJMlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:41:11 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:53742
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755310Ab2EJMlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:41:08 -0400
Message-ID: <4FABB758.7000702@compulab.co.il>
Date: Thu, 10 May 2012 15:40:56 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120409 Thunderbird/10.0.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Wolfgang Denk <wd@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Handling of modular boards
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <201205041934.08830.arnd@arndb.de> <20120504203357.6B79B206451@gemini.denx.de> <20120504220944.GT14230@opensource.wolfsonmicro.com>
In-Reply-To: <20120504220944.GT14230@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/05/12 01:09, Mark Brown wrote:
> On Fri, May 04, 2012 at 10:33:57PM +0200, Wolfgang Denk wrote:
> 
>> On the other hand, some of the issues we're trying to solve here
>> for the kernel are also present in the boot loader, so this needs to
>> do this anyway - whether by inserting new or modifying (enabling or
>> disabling) existing properties in the DT is not really relevant here.
> 
> FWIW if the bootloader can usefully handle this stuff I think that's a
> good approach but there is substantial variation in quality of
> implementation between bootloaders and even when the bootloader is a
> good one it's not always practical to update it or the data it relies
> on.

I agree on this (and also with Ben), all our boards/extensions/base boards/etc
can be discovered in the boot loader and we will use the DT to pass
the relevant information on the attached extensions and used base board.

Also, most (if not all) of our boards/extensions have I2C EEPROM which
describes the devices on that board/extension which is useful for
building/extending the DT in the bootloader.

- -- 
Regards,
Igor.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPq7dXAAoJEBDE8YO64Efag7sQAJ4Ipk/A24p6mO6ROtcd+q2s
gGlEjLHeZ7sNPnwCOCakCgX7+SYXKBv6w5aWKM70eLDUfoVLu9eaUeT4sYd2fGtR
4xFVkcYRenzkuO7MZ3GccAAF4Hg4WwMAn/3StIJU6pyBY7OmOsbqnoTa7PJjKr/J
HwwM8g8eo3q4tg2sB5P922Fol61BK2Wo3S7I9kzHtnwUx9yW3aG2mf/ublfXHUkQ
3RKfXrdREFJL30j9SrJzh6wVqQoE9Y7UrYs1BIiAs9AL/d2+eYgSPNKh/iBw+26f
V+Tr8t9xPyP1b1HGUjLVtGmwWtLncws2kfYnMcjvLKgES967SRbSboqRqwJL95yR
h9xKoVVrqC9lCXZn/uZCHmRaj/7DaPqr4/tbJefJTcU4ErS7bv/QxXARaj41SmS9
sq8A+qefiKaleBfinmiXjoCu8QcUKmfLF8oLt52tylb/4CUnipf4jLbnQ9fdPxGB
gQnrlg6T3WVTR7fzhOsXrgHQvocJa+3/YSYUyWbNvfjJBWFV6ZqERjTQCvhkXivG
bbwBn6tHAol+tRAUfGudlwzcaZZGbJ+vvK/GmSCI+tSfgz++O9uvd0spklatB4ab
NyikQLZBvSufnyWSY6Mp3iShhwgGZosxu9OGgQzclEh1tC8LQEbxOwETaRi/7uGq
PkkXsoPrmBc0C0dO+fIc
=icYW
-----END PGP SIGNATURE-----
