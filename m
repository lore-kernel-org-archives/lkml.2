Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0KIS7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:59:11 -0500
Received: from imr4.ericy.com ([198.24.6.8]:34776 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0KIS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:59:08 -0500
Subject: Re: [PATCH 02/11] hwmon: applesmc: Relax the severity of device
 init failure (rev2)
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1289315711-3011-3-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
	 <1289315711-3011-3-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 10:57:13 -0800
Message-ID: <1289329033.22931.213.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:15 -0500, Henrik Rydberg wrote:
> The device init is used to reset the accelerometer. Failure to reset
> is not severe enough to stop loading the module or to resume from
> hibernation.  This patch relaxes failure to a warning and drops
> output in case of success.
> 
> Cc: stable@kernel.org
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

Thanks,
Guenter


