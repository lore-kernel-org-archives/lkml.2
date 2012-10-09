Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2JIHez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:34:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2JIHey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121009071343.GW8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
	<20121009041947.GB8237@opensource.wolfsonmicro.com>
	<CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
	<20121009071343.GW8237@opensource.wolfsonmicro.com>
Date: Tue, 9 Oct 2012 15:34:52 +0800
Message-ID: <CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
From: Ming Lei <ming.lei@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 3:13 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

>> If so, I am wondering why the driver has to call request_firmware()?
>> Looks just bypassing request_firmware() is fine for the driver, doesn't it?
>
> A driver has no way to tell if the firmware is there or not without
> asking for it.

Yes, I agree, and my question is only on what you mentioned:

              "it didn't want to load an optional image"

maybe I misunderstood the above, never mind, :-)

So one driver should suppose the firmware is there, and the
firmware shouldn't be zero length, because the driver always
expects getting some bytes by calling request_firmware().


Thanks,
--
Ming Lei
