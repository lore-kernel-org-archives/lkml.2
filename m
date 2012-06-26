Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2FZTK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:10:26 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42771 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893Ab2FZTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:10:25 -0400
Date: Tue, 26 Jun 2012 21:10:23 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: xilinx: Read clock frequency directly from DT node
Message-ID: <20120626191023.GI735@spo001.leaseweb.com>
References: <1340261140-10166-1-git-send-email-monstr@monstr.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340261140-10166-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> Do not use clock-frequency property from parent node.
> Use it from watchdog node.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Added to linux-watchdog-next.

Kind regards,
Wim.

