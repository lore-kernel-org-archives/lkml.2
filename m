Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab0EDTQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:16:34 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50965 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0EDTQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:16:33 -0400
Date: Tue, 4 May 2010 21:16:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alex Murray <murray.alex@gmail.com>
Subject: Re: [PATCH 2/2] hwmon: applesmc: Add temperature sensor labels to
 sysfs interface (rev2)
Message-ID: <20100504211629.40d0d1bf@hyperion.delvare>
In-Reply-To: <1272980343-3880-2-git-send-email-rydberg@euromail.se>
References: <1272980343-3880-1-git-send-email-rydberg@euromail.se>
	<1272980343-3880-2-git-send-email-rydberg@euromail.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue,  4 May 2010 15:39:03 +0200, Henrik Rydberg wrote:
> From: Alex Murray <murray.alex@gmail.com>
> 
> The Apple SMC uses a systematic labeling scheme for the hardware
> temperature sensors. This scheme is currently hidden from
> userland. Since the sensor set, and consequently the numbering,
> differs between models, an extensive database of configurations is
> required for an application such as fan control. This patch adds the
> SMC labels to the hwmon sysfs interface, allowing applications to use
> the sensors more intelligibly.
> 
> [rydberg@euromail.se: fixed error handling]
> Signed-off-by: Alex Murray <murray.alex@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |  148 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 147 insertions(+), 1 deletions(-)
> (...)

Applied, thanks.

-- 
Jean Delvare
