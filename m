Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0LXQOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 11:14:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56629 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752585Ab0LXQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 11:14:01 -0500
Date: Fri, 24 Dec 2010 16:14:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] ASoC: codecs: Fix register cache incoherencies
Message-ID: <20101224161412.GD16614@opensource.wolfsonmicro.com>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
 <20101224145706.GA16614@opensource.wolfsonmicro.com>
 <4D14BE81.6000907@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D14BE81.6000907@metafoo.de>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 04:38:41PM +0100, Lars-Peter Clausen wrote:

> If there are no other issues with this series, I'll resend it with adjusted commit
> messages in a few days.

Everything except the WM8753 patch looks OK - I *think* the WM8753 patch
is fine, but on the other hand the driver is clearly quite badly broken
at the moment so we can hardly make the situation worse.
