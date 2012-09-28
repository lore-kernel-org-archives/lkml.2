Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab2I1I50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:57:26 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55650 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2I1I5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:57:21 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 04:57:21 EDT
Message-ID: <1348822189.15949.5.camel@cumari.coelho.fi>
Subject: Re: [PATCH 3.6-rc3 v2] wlcore: Declare MODULE_FIRMWARE usage
From: Luciano Coelho <luca@coelho.fi>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 28 Sep 2012 11:49:49 +0300
In-Reply-To: <1346267373-19591-1-git-send-email-tim.gardner@canonical.com>
References: <1346266668.3935.23.camel@cumari.coelho.fi>
	 <1346267373-19591-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-29 at 13:09 -0600, Tim Gardner wrote:
> Declare any firmware that might be used by this driver.
> If all drivers declare their firmware usage, then a sufficiently
> complete list of firmware files can then be used to pare down
> the external linux-firmware package to just the files in actual use.
> 
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

Applied, thank you!

--
Luca.

