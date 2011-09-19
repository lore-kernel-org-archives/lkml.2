Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1ITJtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:49:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43385 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752742Ab1ITJtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:49:51 -0400
Date: Mon, 19 Sep 2011 23:16:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [alsa-devel] [PATCH 05/17] ASoC: twl6040: Chip initialization
 cleanup
Message-ID: <20110919221632.GD23179@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <1316090379-30760-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316090379-30760-6-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 03:39:27PM +0300, Peter Ujfalusi wrote:
> There is no need to write to the vio registers at probe time, since most
> them either read only, or shared with MFD or not used.
> On the other hand it is a good idea to updated the ASICREV register in
> the cache at this time.

Applied, thanks.
