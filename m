Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2JIIRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:17:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48325 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab2JIIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:17:49 -0400
Date: Tue, 9 Oct 2012 16:52:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with
 vmalloc()
Message-ID: <20121009074138.GB8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
 <20121009041947.GB8237@opensource.wolfsonmicro.com>
 <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
 <20121009071343.GW8237@opensource.wolfsonmicro.com>
 <CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:34:52PM +0800, Ming Lei wrote:

> Yes, I agree, and my question is only on what you mentioned:

>               "it didn't want to load an optional image"

> maybe I misunderstood the above, never mind, :-)

> So one driver should suppose the firmware is there, and the
> firmware shouldn't be zero length, because the driver always
> expects getting some bytes by calling request_firmware().

The point is that there's some firmware which the driver wants to load
but where it's happy to continue if the user didn't provide one and
doesn't want to introduce needless delays.
