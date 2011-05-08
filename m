Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1EHOel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:34:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44008 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751206Ab1EHOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:34:39 -0400
Date: Sun, 8 May 2011 15:34:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] SOC: UDA134x: Remove POWER_OFF_ON_STANDBY define.
Message-ID: <20110508143446.GD15968@opensource.wolfsonmicro.com>
References: <1304426792-23540-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304426792-23540-1-git-send-email-marek.belisko@open-nandra.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:46:32PM +0200, Marek Belisko wrote:
> Define POWER_OFF_ON_STANDBY cause trobles when trying to get some
> sound from codec because code for bias setup was not compiled
> (define wasn't defined). This define was removed in commit:
> cc3202f5 but again introduced by commit: f0fba2ad1 which then
> completely break codec functionality so remove it again.

Applied, thanks.
