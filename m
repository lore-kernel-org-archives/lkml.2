Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0IHP3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:29:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32449 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0IHP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:29:19 -0400
Date: Wed, 8 Sep 2010 17:29:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add support for max6695 and max6696 to lm90 
 driver
Message-ID: <20100908172902.6ed57505@hyperion.delvare>
In-Reply-To: <20100908135654.GA11277@ericsson.com>
References: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
	<20100906181229.2e25db07@hyperion.delvare>
	<20100908102816.GA10676@ericsson.com>
	<20100908134854.2c60f406@hyperion.delvare>
	<20100908135654.GA11277@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 06:56:54 -0700, Guenter Roeck wrote:
> Too bad - registers 0x16 and 0x17 exist on both 6658 and 6659. So the only way to detect 6659 
> would be the address (0x4d or 0x4e), and we would mis-detect it on 0x4c. Is that worth it ?

I'd say adding support for the MAX6659 is worth it. Just don't add
detection. That is, all of MAX6657, 6658 and 6658 should be detected as
max6657, which has the minimum set of features. But if someone declares
a "max6659" device either as part of the platform data or from
user-space, then the driver should expose all the chip features.

Deal?

-- 
Jean Delvare
