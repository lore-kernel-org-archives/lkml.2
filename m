Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1IZIdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:33:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15243 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1IZIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:33:08 -0400
Date: Mon, 26 Sep 2011 10:32:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [lm-sensors] CONFIG_THERMAL_HWMON configuration option removal
Message-ID: <20110926103255.02db677c@endymion.delvare>
In-Reply-To: <20110926033740.GA5637@ericsson.com>
References: <20110926033740.GA5637@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun, 25 Sep 2011 20:37:40 -0700, Guenter Roeck wrote:
> I just noticed the folllowing in feature-removal-schedule.txt:
> 
> What:   CONFIG_THERMAL_HWMON
> When:   January 2009
> Why:    This option was introduced just to allow older lm-sensors userspace
>         to keep working over the upgrade to 2.6.26. At the scheduled time of
>         removal fixed lm-sensors (2.x or 3.x) should be readily available.
> Who:    Rene Herman <rene.herman@gmail.com>
> 
> I don't know what the lm-sensors changes are, and if they have been implemented.
> Is it time to remove the configuration option ?

Not sure where you looked, but it's already gone. See commit
ab92402af04c151c26541eb28e1c26286a429db5.

-- 
Jean Delvare
