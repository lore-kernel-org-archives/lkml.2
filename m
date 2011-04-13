Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1DMMxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:53:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38746 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1DMMxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:53:34 -0400
Date: Wed, 13 Apr 2011 14:53:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: wni@nvidia.com
Cc: guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, achew@nvidia.com
Subject: Re: [PATCH] [hwmon] lm90: Support NCT1008 sensor
Message-ID: <20110413145321.181484bf@endymion.delvare>
In-Reply-To: <1302695508-2002-1-git-send-email-wni@nvidia.com>
References: <1302695508-2002-1-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Wed, 13 Apr 2011 19:51:48 +0800, wni@nvidia.com wrote:
> From: Wei Ni <wni@nvidia.com>
> 
> NCT1008 is the register-compatible with the ADM1032 and ADT7461,
> so support it in this lm90 driver.
> And add alarm function, suspend/resume callback.

We already have a patch pending adding support for the NCT1008:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-lm90-01-add-support-for-adt7461a-and-nct1008.patch

Your own patch should apply on top of this, and only focus on adding
support for the new features. BTW, you stand a better chance of getting
your changes reviewed and accepted quickly if you split them into
logical steps. For example, suspend/resume support would be useful on
its own, so it could be a separate patch, etc.

-- 
Jean Delvare
