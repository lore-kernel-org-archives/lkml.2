Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1AYLzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:55:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49587 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1AYLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:55:17 -0500
Subject: Re: [PATCH 1/2 v2] ASoC: Fix codec device id format used by some
 dai_links
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295903363-4433-1-git-send-email-lars@metafoo.de>
References: <1295903363-4433-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:55:12 +0000
Message-ID: <1295956512.3322.74.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 22:09 +0100, Lars-Peter Clausen wrote:
> The id part of an I2C device name is created with the "%d-%04x" format string.
> 
> So for example for an I2C device which is connected to the adapter with the id 0
> and has its address set to 0x1a the id part of the devices name would be
> "0-001a".
> 
> Currently some sound board drivers have the id part the codec_name field of
> their dai_link structures set as if it had been created by a "%d-0x%x" format
> string. For example "0-0x1a" instead of "0-001a".
> 
> As a result there is no match between the codec device and the dai_link and no
> sound card is instantiated.
> 
> This patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 

Both

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

