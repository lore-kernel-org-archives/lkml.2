Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2IFPCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:02:53 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:46395 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756550Ab2IFPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <1338375394-16268-3-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
	<1338375394-16268-3-git-send-email-kishon@ti.com>
Date: Thu, 6 Sep 2012 20:32:41 +0530
Message-ID: <CAAe_U6Ji3KbqkFcBsZ8m-oLQBHyOQfuKTz+NkaoQyxMLascU5g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] arm: omap: remove ocp2scp_usb_phy_ick clock node
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 30, 2012 at 4:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> "ocp2scp_usb_phy_ick" clock node was a fake clock node created
> to control MODULEMODE of ocp2scp. Since the hwmod for ocp2scp is now added
> (which can be used to control MODULEMODE) this clock node is removed.
>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

If there isn't any comments for this patch, can someone queue it up?

Thanks
Kishon
