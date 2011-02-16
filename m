Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab1BPEv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:51:27 -0500
Received: from imr3.ericy.com ([198.24.6.13]:60077 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab1BPEvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:51:24 -0500
Date: Tue, 15 Feb 2011 20:50:35 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Dirk Eibach <eibach@gdsys.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add support for Texas Instruments ADS1015
Message-ID: <20110216045035.GA12173@ericsson.com>
References: <20110214112228.59269651@endymion.delvare>
 <1297689710-17840-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1297689710-17840-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 08:21:50AM -0500, Dirk Eibach wrote:
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
> Changes since v1:
> - fixed/extended Documentation
> - removed unused register definitions
> - hardcoded PGA fullscale table size
> - made sure patch applies against v2.6.38-rc4
> - reordered functions to avoid forward declaration
> - results from i2c_smbus_read_word_data() are handled correctly
> - moved locking into ads1015_read_value()
> - removed unnecessray clearing of bit
> - proper error handling in ads1015_read_value()
> - use DIV_ROUND_CLOSEST for scaling result
> - removed detect()
> 
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Jean,

any further comments ?

If not, do you want me to apply it to my tree, or do you want to take it into yours ?

Thanks,
Guenter
