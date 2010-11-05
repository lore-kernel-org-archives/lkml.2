Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0KEJAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:00:50 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48496 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab0KEJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:00:47 -0400
Message-ID: <4CD3C795.3050006@euromail.se>
Date: Fri, 05 Nov 2010 10:00:05 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 8/8] hwmon: applesmc: Update copyright information
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288511434-5662-9-git-send-email-rydberg@euromail.se> <20101105030923.GG28308@ericsson.com>
In-Reply-To: <20101105030923.GG28308@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PEI9W-0007Xy-C8.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PEI9W-0007Xy-C8 f0078aff51c831085d15b34666b08236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> One suggestion - since you did that much rework, it would be nice if you could fix
> the remaining few checkpatch errors in the file as well (and possibly the warnings).


Absolutely. Regarding the warnings, I was deliberately leaving the over-80 lines
since they appear in static array listings, and as such seem to be pretty common
in the kernel. I know these things have been discussed before. :-)

Cheers,
Henrik
