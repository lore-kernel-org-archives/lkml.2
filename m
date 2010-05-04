Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0EDLir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:38:47 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51559 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0EDLiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:38:46 -0400
Date: Tue, 4 May 2010 13:32:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alex Murray <murray.alex@gmail.com>
Subject: Re: [PATCH] hwmon: applesmc: Add temperature sensor labels to sysfs
  interface
Message-ID: <20100504133200.34413e2b@hyperion.delvare>
In-Reply-To: <4BE001E7.9030605@euromail.se>
References: <1272966929-14501-1-git-send-email-rydberg@euromail.se>
	<20100504120638.70244e8e@hyperion.delvare>
	<4BE001E7.9030605@euromail.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 May 2010 13:15:51 +0200, Henrik Rydberg wrote:
> Jean Delvare wrote:
> [...]
> >> @@ -1578,6 +1717,8 @@ static int __init applesmc_init(void)
> >>  		}
> >>  		ret = sysfs_create_file(&pdev->dev.kobj,
> >>  						temperature_attributes[i]);
> > 
> > Missing error handling.
> > 
> >> +		ret = sysfs_create_file(&pdev->dev.kobj,
> >> +						label_attributes[i]);
> >>  		if (ret)
> >>  			goto out_temperature;
> >>  	}
> >
> 
> Shoot, my bad review. Will send a new patch. While at it, the same function
> seems to leak fan attribute groups. Want me to correct such issues (in another
> patch)?

Yes please. As a bugfix, that would even be a candidate for 2.6.34. I
have another patch (for asc7621) pending already.

-- 
Jean Delvare
