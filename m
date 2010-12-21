Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0LUG6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 01:58:19 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37838 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023Ab0LUG6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 01:58:18 -0500
Date: Tue, 21 Dec 2010 08:58:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: srinath@mistralsolutions.com
Cc: linux-omap@vger.kernel.org, jdk@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        nagendra@mistralsolutions.com, umeshk@mistralsolutions.com,
        sshtylyov@mvista.com, manjugk@ti.com, babli@ti.com
Subject: Re: [Patch v5] AM35xx: Craneboard: Add USB EHCI support
Message-ID: <20101221065809.GB2921@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <[PATCH]AM35xx-Craneboard-Add-USB-EHCI-support>
 <1292850523-14583-1-git-send-email-srinath@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1292850523-14583-1-git-send-email-srinath@mistralsolutions.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 06:38:43PM +0530, srinath@mistralsolutions.com wrote:
>From: Srinath <srinath@mistralsolutions.com>
>
>AM3517/05 Craneboard has one EHCI interface on board using port1.
>
>GPIO35 is used as power enable.
>GPIO38 is used as port1 PHY reset.
>
>History:
>http://marc.info/?l=linux-omap&w=2&r=1&s=Craneboard%253A%2BAdd%2BUSB%2BEHCI%2Bsupport&q=b
>
>Signed-off-by: Srinath <srinath@mistralsolutions.com>

Tony, do you want to make a pull request for you ? I guess this would
only go on next merge window.

If you want to take yourself, here's my acked-by:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
