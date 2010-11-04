Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0KDWxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:53:47 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:49806 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753475Ab0KDWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:53:46 -0400
Message-ID: <4CD33975.4010100@eukrea.com>
Date: Thu, 04 Nov 2010 23:53:41 +0100
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        u.kleine-koenig@pengutronix.de, amit.kucheria@canonical.com
Subject: Re: [PATCHv2 2/2] ARM: imx: Add mx53 support to common msl functions.
References: <1288910773-3098-1-git-send-email-Dinh.Nguyen@freescale.com> <1288910773-3098-2-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1288910773-3098-2-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4140215434258001279
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 04/11/2010 23:46, Dinh.Nguyen@freescale.com a écrit :
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> Add mx53 support to cpu.c and mm.c.
>
> Also change the method to get the silicon version from the
> documented IIM SREV register instead of reading the ROM code.
>
if iMX5x IIM is like iMX27/31/35, you may need to enable the iim clock before 
accessing the registers.

Eric

