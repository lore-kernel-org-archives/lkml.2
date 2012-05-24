Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2EXR0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:26:17 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:55436 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741Ab2EXR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:26:15 -0400
Date: Thu, 24 May 2012 19:26:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Anthony Olech <Anthony.Olech@diasemi.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] Watchdog: DA9052/53 PMIC watchdog support v5
Message-ID: <20120524172610.GV3074@spo001.leaseweb.com>
References: <1337864474.20377.3.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337864474.20377.3.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

> This driver adds support for the watchdog functionality provided by the Dialog
> Semiconductor DA9052 PMIC chip.
> 
> Tested on samsung smdkv6410 and i.mx53 QS boards.
> 
> Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

removed last driver_data.lock's and added to linux-watchdog-next.

Kind regards,
Wim.

