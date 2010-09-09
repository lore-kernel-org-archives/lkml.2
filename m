Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0IISLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:11:45 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22776 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0IISLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:11:43 -0400
Date: Thu, 9 Sep 2010 20:11:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] lm75: some optimisations
Message-ID: <20100909201128.3840431b@hyperion.delvare>
In-Reply-To: <20100909175537.GA16681@ericsson.com>
References: <1284052336-25864-1-git-send-email-shubhrajyoti@ti.com>
	<20100909175537.GA16681@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 10:55:37 -0700, Guenter Roeck wrote:
> General comments:
> 
> - Please select a more descriptive headline, such as
> 	hwmon: lm75: Add __devinit and __devexit section initializers
> 
> - It is useful to provide the patch version to reduce confusion and enable
>   version tracking.
>   Example:
> 	[PATCH v3] hwmon: lm75: Add __devinit and __devexit section initializers
> 
> - Please cc linux-kernel@vger.kernel.org and Jean Delvare <khali@linux-fr.org>.

Please do NOT CC linux-kernel@vger.kernel.org. We have a mailing list
dedicated to hardware monitoring, there's no point to add to the 200,000
messages (literally) LKML gets every year. The more messages a list
gets, the fewer readers it has.

As for CC'ing me, it doesn't hurt, but doesn't make a difference either,
as I read the lm-sensors list carefully anyway.

-- 
Jean Delvare
