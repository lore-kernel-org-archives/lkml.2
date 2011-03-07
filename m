Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1CGLEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:04:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44700 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1CGLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:04:43 -0500
Subject: Re: [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario management
 code.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299481500-5481-1-git-send-email-lars@metafoo.de>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 11:04:38 +0000
Message-ID: <1299495878.3377.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 08:04 +0100, Lars-Peter Clausen wrote:
> It has been proven to be inflexible to do scenario management in kernel space.
> 

We have UCM for this now too :)

> Since actual neo1973 board support has not been merged in mainline and this
> patch has been in the neo1973 tree for some time now it should be safe to remove
> this functionality without breaking existing userspace.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  sound/soc/samsung/neo1973_wm8753.c |  148 +++---------------------------------
>  1 files changed, 11 insertions(+), 137 deletions(-)

Just had a quick look. All 

Acked-by: Liam Girdwood <lrg@ti.com>


