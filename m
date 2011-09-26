Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1IZOdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:33:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47839 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1IZOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:33:22 -0400
Subject: Re: [PATCHv8] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Mon, 26 Sep 2011 17:36:07 +0300
In-Reply-To: <1317047152-18809-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1317047152-18809-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317047776.9442.10.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 16:25 +0200, David Wagner wrote:
> +MODULE_PARM_DESC(volume,
> +       "Format: volume=<ubi_num>:<vol_id>\n"
> +       "Create a ubiblk device at init time.  Useful for mounting it as root "
> +       "device."); 

Sorry, you still did not change the documentation. It should describe
what this parameter is. Now I see that it requires volume ID.

-- 
Best Regards,
Artem Bityutskiy

