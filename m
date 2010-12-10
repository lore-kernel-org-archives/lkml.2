Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0LJLeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:34:46 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58276 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211Ab0LJLep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:34:45 -0500
Message-ID: <4D021047.9080300@ti.com>
Date: Fri, 10 Dec 2010 05:34:31 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
CC: omar.ramirez@ti.com, linux-kernel@vger.kernel.org,
        felipe.contreras@gmail.com, ohad@wizery.com,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv2 0/4] staging: tidspbridge - misc fixes
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
In-Reply-To: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Guzman Lugo wrote, on 12/09/2010 09:55 PM:
> * V2
>   - rebase to the latest
>   - remove patches no needed at this moment
>
> This set of patches fix some issues found in lastest tree.
>
> Fernando Guzman Lugo (4):
>    staging: tidspbridge - use GTP7 for DSP stack dump
>    staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
>    staging: tidspbridge - remove disabling twl when printing DSP stack
>    staging: tidspbridge - change mmufault tasklet to a workqueue
>
>   drivers/staging/tidspbridge/core/_deh.h            |    2 +-
>   drivers/staging/tidspbridge/core/dsp-clock.c       |   17 ++++---
>   drivers/staging/tidspbridge/core/ue_deh.c          |   55 +++++++++++--------
>   .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +-
>   4 files changed, 46 insertions(+), 32 deletions(-)
>
Suggest looping in Linux-omap as well.

-- 
Regards,
Nishanth Menon
