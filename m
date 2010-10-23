Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0JWIIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:08:47 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:51895 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753611Ab0JWIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:08:43 -0400
Message-ID: <4CC297FE.1060305@eukrea.com>
Date: Sat, 23 Oct 2010 10:08:30 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv6 2/3] ARM: mx5: Add gpio-keys to mx51 babbage board
References: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com> <1287801976-5324-2-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1287801976-5324-2-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10952191344733564287
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 23/10/2010 04:46, Dinh.Nguyen@freescale.com a écrit :
> @@ -281,6 +299,7 @@ __setup("otg_mode=", babbage_otg_mode);
>   static void __init mxc_board_init(void)
>   {
>   	struct pad_desc usbh1stp = MX51_PAD_USBH1_STP__USBH1_STP;
> +	struct pad_desc power_key = MX51_PAD_EIM_A27__GPIO_2_21
>
here, this line leads to a compile error because of a missing ';' at the end.

Eric
