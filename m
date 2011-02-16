Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1BPIj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:39:59 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:60855 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1BPIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:39:57 -0500
Message-ID: <4D5B8D47.2010809@stericsson.com>
Date: Wed, 16 Feb 2011 09:39:35 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/9] mfd-core: rename platform_data field of mfd_cell
 to mfd_data
References: <1297808729-21110-1-git-send-email-dilinger@queued.net> <1297808729-21110-2-git-send-email-dilinger@queued.net>
In-Reply-To: <1297808729-21110-2-git-send-email-dilinger@queued.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 11:25 PM, Andres Salomon wrote:
> Rename the platform_data variable to imply a distinction between
> common platform_data driver usage (typically accessed via
> pdev->dev.platform_data) and the way MFD passes data down to
> clients (using a wrapper named mfd_get_data).
>
> All clients have already been changed to use the wrapper function,
> so this can be a quick single-commit change that only touches things
> in drivers/mfd.
>
> Signed-off-by: Andres Salomon<dilinger@queued.net>
>    

Thanks, I like easy-to-read code.
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
