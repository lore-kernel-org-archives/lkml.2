Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1KAST5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:19:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44699 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab1KASTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110311110370.3541@pobox.suse.cz>
References: <1318421062.2336.4.camel@x61.thuisdomein>
	<alpine.LNX.2.00.1110311110370.3541@pobox.suse.cz>
Date: Tue, 1 Nov 2011 16:19:54 -0200
Message-ID: <CAOMZO5DZ6KYa_SLVavorPPyV_Ggspa4Cae+eK7oj1mh=O4J4+w@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] ARM: imx: Fix typo 'MACH_MX31_3DS_MXC_NAND_USE_BBT'
From: Fabio Estevam <festevam@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 8:12 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 12 Oct 2011, Paul Bolle wrote:
>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> This is trivial because this is what apparently was intended. On the
>> other hand this should open code paths that were hidden until now. So
>> perhaps this needs the maintainer's approval. (I cannot meaningfully
>> test this.)
>
> I'd like to have this tested by some relevant people before taking it
> myself (added some CCs).

On a mx31pdk board I get the following with this patch applied and
CONFIG_MACH_MX31_3DS_MXC_NAND_USE_BBT selected:

NAND device: Manufacturer ID: 0xec, Chip ID: 0xaa (Samsung NAND 256MiB
1,8V 8-bit)
Bad block table not found for chip 0
Bad block table not found for chip 0
Scanning device for bad blocks
Registering mxc_nand as whole device

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
