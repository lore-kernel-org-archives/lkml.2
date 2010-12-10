Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0LJQQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:16:24 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48220 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950Ab0LJQQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:16:23 -0500
MIME-Version: 1.0
In-Reply-To: <4D021047.9080300@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
	<4D021047.9080300@ti.com>
Date: Fri, 10 Dec 2010 10:16:14 -0600
Message-ID: <AANLkTi=2Med5qeYNHRkFAAU1syK1Y1-cAfqWz9uAZsFU@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] staging: tidspbridge - misc fixes
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Nishanth Menon <nm@ti.com>
Cc: omar.ramirez@ti.com, linux-kernel@vger.kernel.org,
        felipe.contreras@gmail.com, ohad@wizery.com,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 5:34 AM, Nishanth Menon <nm@ti.com> wrote:
> Fernando Guzman Lugo wrote, on 12/09/2010 09:55 PM:
>>
>> * V2
>>  - rebase to the latest
>>  - remove patches no needed at this moment
>>
>> This set of patches fix some issues found in lastest tree.
>>
>> Fernando Guzman Lugo (4):
>>   staging: tidspbridge - use GTP7 for DSP stack dump
>>   staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
>>   staging: tidspbridge - remove disabling twl when printing DSP stack
>>   staging: tidspbridge - change mmufault tasklet to a workqueue
>>
>>  drivers/staging/tidspbridge/core/_deh.h            |    2 +-
>>  drivers/staging/tidspbridge/core/dsp-clock.c       |   17 ++++---
>>  drivers/staging/tidspbridge/core/ue_deh.c          |   55
>> +++++++++++--------
>>  .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +-
>>  4 files changed, 46 insertions(+), 32 deletions(-)
>>
> Suggest looping in Linux-omap as well.

Yes, it was weird linux-omap was not showed by get_maintainer.pl script :(.

Regards,
Fernando.

>
> --
> Regards,
> Nishanth Menon
>
