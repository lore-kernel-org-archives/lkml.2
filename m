Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab0GWSWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:22:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41078 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0GWSWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:22:01 -0400
Subject: Re: [PATCH v2 00/12] sound/alsa/soc/codec: fix memory leak and
 resource relaim in error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 19:21:53 +0100
Message-ID: <1279909313.3076.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 05:53 +0000, Axel Lin wrote:
> This serial of patches fixes memory leak and resource relaim in error path
> 
> I made a mistake that changed the subject line for some of the update patches.
> So. here is a re-send and all patches are marked as v2.
> 

Ok, we will keep this in reserve atm if multi-component is held up.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

