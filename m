Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0EASk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:40:26 -0400
Received: from bamako.nerim.net ([62.4.17.28]:51021 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab0EASkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:40:24 -0400
Date: Sat, 1 May 2010 20:40:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hwmon: applesmc: Add generic support for MacBook
 Pro 7
Message-ID: <20100501204021.7d65542b@hyperion.delvare>
In-Reply-To: <1272663486-16945-3-git-send-email-rydberg@euromail.se>
References: <1272663486-16945-1-git-send-email-rydberg@euromail.se>
	<1272663486-16945-2-git-send-email-rydberg@euromail.se>
	<1272663486-16945-3-git-send-email-rydberg@euromail.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, 30 Apr 2010 23:38:06 +0200, Henrik Rydberg wrote:
> This patch adds generic support for the MacBook Pro 7 family
> based on the 7,1 model.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> (...)

All 3 patches applied. I guess they can be scheduled for merge in
2.6.35-rc1?

-- 
Jean Delvare
