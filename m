Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1DWVAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 17:00:43 -0400
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:57699 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab1DWVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 17:00:42 -0400
Message-ID: <4DB33F4A.3080903@gmail.com>
Date: Sat, 23 Apr 2011 23:06:18 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Lanikai/3.1.9
MIME-Version: 1.0
To: Len Brown <len.brown@intel.com>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] thermal: Drop CONFIG_THERMAL_HWMON
References: <20110423150703.78ba86db@endymion.delvare>
In-Reply-To: <20110423150703.78ba86db@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1QDjwS-00065S-4R
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=-3.638, vereist 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, FREEMAIL_FROM 0.50, PROLO_TRUST_RDNS -3.00,
	RDNS_DYNAMIC 0.98, RFC_ABUSE_POST 0.00, SPF_NEUTRAL 0.78)
X-ZiggoSMTP-MailScanner-From: rene.herman@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2011 03:07 PM, Jean Delvare wrote:

> It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
> Anybody running a kernel>= 2.6.40 would also be running a recent
> enough version of lm-sensors.
>
> Signed-off-by: Jean Delvare<khali@linux-fr.org>
> Cc: Rene Herman<rene.herman@gmail.com>
> Cc: Len Brown<len.brown@intel.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.
