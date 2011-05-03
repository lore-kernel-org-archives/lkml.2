Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1ECKAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:00:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37263 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751509Ab1ECKAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:00:49 -0400
Date: Tue, 3 May 2011 11:00:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] SOC: UDA134x: Enable POWER_OFF_ON_STANDBY define.
Message-ID: <20110503100042.GA1762@opensource.wolfsonmicro.com>
References: <1304415149-19725-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304415149-19725-1-git-send-email-marek.belisko@open-nandra.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:32:29AM +0200, Marek Belisko wrote:
> Without this define we can't get any sound from codec so enable
> it by default. This define unlock bias settings which control
> power control for DAC and ADC (by default 0 0 which is off off).

If this is essential why is it optional in the first place?
