Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1IWKwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:52:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54143 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752429Ab1IWKwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:52:47 -0400
Date: Fri, 23 Sep 2011 11:52:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 5/6] ASoC: omap-mcpdm: Correct the supported number of
 channels
Message-ID: <20110923105245.GE3165@opensource.wolfsonmicro.com>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
 <1316760584-27426-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316760584-27426-6-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 09:49:43AM +0300, Peter Ujfalusi wrote:
> OMAP4 McPDM supports 5 downlink (playback), and
> 3 uplink (capture) channels.

Applied, thanks.
