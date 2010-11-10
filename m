Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0KJWel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:34:41 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56109 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757209Ab0KJWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:34:39 -0500
Message-ID: <4CDB1DB8.5070302@euromail.se>
Date: Wed, 10 Nov 2010 23:33:28 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: (applesmc) Fix checkpatch errors and value
 range checks
References: <1289428231-14950-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1289428231-14950-1-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGJER-0001jc-5c.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PGJER-0001jc-5c 643152accb28a5bf9a6a69e17be1d7d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 11:30 PM, Guenter Roeck wrote:

> This patch fixes all checkpatch errors and most of the checkpatch warnings.
> It also fixes the range check in applesmc_store_fan_speed().
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> v2:
> - Moved change in applesmc_key_at_index_store() into a previous patch
>   (Introduce a register lookup table) where a range check was added as well.
> - Updated description to indicate that a minor bug was fixed in addition
>   to the formatting changes.


Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
