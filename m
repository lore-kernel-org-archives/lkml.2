Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0KJWtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:49:03 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:39051 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218Ab0KJWtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:49:01 -0500
Message-ID: <4CDB2148.8080404@euromail.se>
Date: Wed, 10 Nov 2010 23:48:40 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] hwmon: (applesmc) Introduce a register lookup table
References: <1289429274-30289-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1289429274-30289-1-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGJT8-0003UD-4x.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PGJT8-0003UD-4x 351e847fca3d98b7d9bfa0ba4462723c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 11:47 PM, Guenter Roeck wrote:

> From: Henrik Rydberg <rydberg@euromail.se>
> 
> One main problem with the current driver is the inability to quickly
> search for supported keys, resulting in detailed feature maps per
> machine model which are cumbersome to maintain.
> 
> This patch adds a register lookup table, which enables binary search
> for supported keys. The lookup also reduces the io frequency, so the
> original mutex is replaced by locks around the actual io.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> [guenter.roeck@ericsson.com: Added value range check to key_at_index_store()]
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> Patch as applied, with added value range check to applesmc_key_at_index_store().


Works nicely, much obliged. It's a wrap. :-)

Thanks,
Henrik
