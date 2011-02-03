Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1BCMwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:52:45 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:50096 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab1BCMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:52:43 -0500
Message-ID: <4D4AA502.4000001@stericsson.com>
Date: Thu, 3 Feb 2011 13:52:18 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/19] ab3100: mfd_cell is now implicitly available to
 drivers
References: <20110202195417.228e2656@queued.net> <20110202200302.0e05c3d0@queued.net>
In-Reply-To: <20110202200302.0e05c3d0@queued.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 05:03 AM, Andres Salomon wrote:
> No need to explicitly set the cell's platform_data/data_size.
>
> In this case, move the ab3100_platform_data pointer from platform_data
> to driver_data.  The only client who makes use of it is also changed.
>
> Signed-off-by: Andres Salomon<dilinger@queued.net>
>    

Looks good, thanks Andres,
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
