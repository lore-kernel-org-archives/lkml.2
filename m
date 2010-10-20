Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0JTJza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:55:30 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:40351 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab0JTJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:55:29 -0400
Message-ID: <4CBEBC66.3080205@euromail.se>
Date: Wed, 20 Oct 2010 11:54:46 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/32] drivers/hwmon/applesmc.c: Use pr_fmt and pr_<level>
References: <20101020035346.GA20178@ericsson.com> <e12d6edddfdcf543308dd81dfb6b7672f578bfb5.1287556801.git.joe@perches.com>
In-Reply-To: <e12d6edddfdcf543308dd81dfb6b7672f578bfb5.1287556801.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P8VOB-0001i2-Bu.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1P8VOB-0001i2-Bu 69c7b549fc5b7e72e16f24acec116ed2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 08:51 AM, Joe Perches wrote:

> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/applesmc.c |   60 ++++++++++++++++++++-------------------------
>  1 files changed, 27 insertions(+), 33 deletions(-)


Minus the comments already provided, all good.

Thanks,
Henrik
