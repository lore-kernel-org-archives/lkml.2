Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1ARBcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:32:06 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:57440 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1ARBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:32:04 -0500
Message-ID: <4D34EE06.8080305@wytron.com.tw>
Date: Tue, 18 Jan 2011 09:33:58 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sinan Akman <sinan@writeme.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v3] spi: New driver for Altera SPI
References: <AANLkTi=D4Rcxbei2oo+EHc6X1O-2Oo+VWHAasK_JLj5W@mail.gmail.com> <1295247869-4968-1-git-send-email-thomas@wytron.com.tw> <4D33EF7C.7030005@writeme.com>
In-Reply-To: <4D33EF7C.7030005@writeme.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 03:27 PM, Sinan Akman wrote:
>> + if (hw->irq >= 0) {
>> + init_completion(&hw->done);
>
> I think you init this twice, once in altera_spi_probe
> below as well.

Hi Sinan,

Thanks. I will remove this one.

- Thomas
