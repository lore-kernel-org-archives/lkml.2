Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1ISLke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:40:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50668 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754664Ab1ISLkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:40:33 -0400
Date: Mon, 19 Sep 2011 12:40:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: Re: [PATCH 07/17] ASoC: twl6040: Lower the initial gains
Message-ID: <20110919114031.GI23727@opensource.wolfsonmicro.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <1316090379-30760-8-git-send-email-peter.ujfalusi@ti.com>
 <20110919110006.GH23727@opensource.wolfsonmicro.com>
 <2033664.fWQvF2IA53@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2033664.fWQvF2IA53@barack>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 02:26:31PM +0300, Péter Ujfalusi wrote:

> Here in twl6040 we also have event handlers to do the ramp up/down on the 
> gains. AFAIK some wm* codec have similar code.

WM8350.
