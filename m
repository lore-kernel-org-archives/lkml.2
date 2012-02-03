Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab2BCRgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:36:12 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34242
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286Ab2BCRgK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:36:10 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1447M1432N98dKzz1202hzz8275bhz2ei2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
Date: Fri, 3 Feb 2012 12:36:04 -0500
From: Chad Dupuis <chad.dupuis@qlogic.com>
To: Masanari Iida <standby24x7@gmail.com>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Dept-ENG Linux Driver <Linux-Driver@qlogic.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [trivial] qla2xxx: Fix typo in qla_bsg.c
In-Reply-To: <1328274925-1809-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.WNT.2.00.1202031234580.2256@N5102REMCQXM4BS.qlogic.org>
References: <1328274925-1809-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
X-X-Sender: cdupuis@qlm.qlogic.com
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks good. Thanks for the catch.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Fri, 3 Feb 2012, Masanari Iida wrote:

> Correct spelling "curent" to "current" in
> drivers/scsi/qla2xxx/qla_bsg.c
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index b1d0f93..a1c6a16 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -745,7 +745,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
>
>                       if (elreq.options != EXTERNAL_LOOPBACK) {
>                               ql_dbg(ql_dbg_user, vha, 0x7020,
> -                                 "Internal: curent port config = %x\n",
> +                                 "Internal: current port config = %x\n",
>                                   config[0]);
>                               if (qla81xx_set_internal_loopback(vha, config,
>                                       new_config)) {
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

