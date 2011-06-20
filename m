Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1FTMUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:20:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53888 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1FTMUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:20:49 -0400
Date: Mon, 20 Jun 2011 13:20:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Premi, Sanjeev" <premi@ti.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "Nilofer, Samreen" <samreen@ti.com>
Subject: Re: [PATCH 1/2] config: omap2+: force fb and dss support as
	built-in
Message-ID: <20110620122032.GJ2082@n2100.arm.linux.org.uk>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org> <1308566761-2850-2-git-send-email-tushar.behera@linaro.org> <B85A65D85D7EB246BE421B3FB0FBB593024D625A5C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D625A5C@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:37:07PM +0530, Premi, Sanjeev wrote:
> [sp] Instead of changing the omap2plus_defconfig, shouldn't the
>      board specific file be fixed instead?

The board specific configuration files in the mainline kernel are
deprecated and are gradually being removed.
