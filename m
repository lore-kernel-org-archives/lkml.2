Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1AXBRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 20:17:06 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:59632 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1AXBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 20:17:05 -0500
Message-ID: <4D3CD38D.4080808@wytron.com.tw>
Date: Mon, 24 Jan 2011 09:19:09 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: Grant Likely <grant.likely@secretlab.ca>, nios2-dev@sopc.et.ntust.edu.tw,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw>	 <1295249542-26743-1-git-send-email-thomas@wytron.com.tw>	 <20110120165430.GA24445@angua.secretlab.ca>	 <4D38AAEB.7020308@wytron.com.tw> <1295612849.23825.26.camel@needafix>
In-Reply-To: <1295612849.23825.26.camel@needafix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,


On 01/21/2011 08:27 PM, Jonas Bonn wrote:
> It would be nice to use the same name for the OpenCores project and the
> device tree identifier, and since "opencores" is already in the name,
> the "oc_" bit is superfluous anyway.  I'd suggest "opencores,tiny-spi"
> in order to match your OpenCores project name.
>
> Versioning of OpenCores cores is not sorted yet.  In order to avoid
> clashing with the versioning/naming scheme that's decided on, please
> just use a neutral version number for now (especially as your core is so
> new).  e.g. "opencores,tiny-spi-0"
>

Thanks. I will update it to "opencores,tiny-spi-1.0".

- Thomas
