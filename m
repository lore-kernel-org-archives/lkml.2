Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1KURjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:39:14 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36207 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1KURjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:39:12 -0500
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275ch8275bhz2ei2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
Date: Mon, 21 Nov 2011 12:38:44 -0500
From: Chad Dupuis <chad.dupuis@qlogic.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Driver <Linux-Driver@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH][TRIVIAL] SCSI, qla2xxx: remove redundant semicolon
In-Reply-To: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
Message-ID: <alpine.WNT.2.00.1111211237510.5992@N5102REMCQXM4BS.qlogic.org>
References: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
X-X-Sender: cdupuis@qlm.qlogic.com
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Sun, 20 Nov 2011, Jesper Juhl wrote:

> One ';' at the end of the return statement is enough.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> drivers/scsi/qla2xxx/qla_nx.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 94bded5..b9b3e5a 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1055,7 +1055,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
>                   "ROM lock failed.\n");
>               return -1;
>       }
> -     return 0;;
> +     return 0;
> }
>
> static int
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

