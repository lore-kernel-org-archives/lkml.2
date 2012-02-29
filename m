Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517Ab2B2J70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:59:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40673 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2B2J7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:59:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <20120228083833.GB18045@n2100.arm.linux.org.uk>
References: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
	<20120228083833.GB18045@n2100.arm.linux.org.uk>
Date: Wed, 29 Feb 2012 10:59:23 +0100
Message-ID: <CACRpkdaTJFL0A3caA4mNjxHTuXLC5u87OZ2yR=1ChiCFQL7c2A@mail.gmail.com>
Subject: Re: RFC: what do we do with system controllers?
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias NILSSON <mattias.i.nilsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 9:38 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 28, 2012 at 06:48:12AM +0100, Linus Walleij wrote:
>> Mainly addressed to Greg but anyone is welcome to join the
>> discussion...
>>
>> Several ARM platforms have system controllers. In this I
>> include all custom terminology such as:
>>
>> - System Control
>> - Chip Controller
>> - Core Module control registers
>> - Power Reset Control Management Units
>> - Multimedia Communications Port
>
> Why do you include this?  If you include this, you should include things
> like SSP/SPI ports, I2C and other such buses.

Mainly because it has these specific MCP controller oddity
functions:

mcp_set_telecom_divisor()
mcp_set_audio_divisor()

i.e. it has some "strangeness" of system controller type
(telecom? que?) But it's quite little and no big deal, drop
it off the list.

Thanks,
Linus Walleij
