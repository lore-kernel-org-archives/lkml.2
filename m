Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1DJXti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 19:49:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57126 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1DJXth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 19:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsOeg/3dJ+YKU43gq/9oJpR9ZaTEjPO4mNlPoQzOKNKtV3Px3UpFfImoFUUslURHxN
         UaQTIe1xARKGAYHZI88Ghb7xMs4Pyo5qEKCNuju6yNuTbcPxIhHJaqVsTOrkHges5Opr
         E2y2zkJWPaxIiM1SCTN3uHQZwUwnm4J7eBz1Q=
MIME-Version: 1.0
In-Reply-To: <20110410181238.GE18601@pengutronix.de>
References: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
	<20110410181238.GE18601@pengutronix.de>
Date: Mon, 11 Apr 2011 07:34:53 +0800
Message-ID: <BANLkTima9-xmm2r6KeQcksvwhk5Wv4oaMA@mail.gmail.com>
Subject: Re: [PATCH] fix build warnings on defconfigs
From: wanlong gao <wanlong.gao@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org, mingo@elte.hu,
        rientjes@google.com, nicolas.ferre@atmel.com, eric@eukrea.com,
        tony@atomide.com, santosh.shilimkar@ti.com,
        khilman@deeprootsystems.com, ben-linux@fluff.org, sam@ravnborg.org,
        manuel.lauss@googlemail.com, galak@kernel.crashing.org,
        anton@samba.org, grant.likely@secretlab.ca, sfr@canb.auug.org.au,
        jwboyer@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/11, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> On Sun, Apr 10, 2011 at 03:04:18AM +0800, wanlong.gao@gmail.com wrote:
>> From: Wanlong Gao <wanlong.gao@gmail.com>
>>
>> Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
>> since BT_L2CAP and BT_SCO had changed to bool configs.
> Pointing out the commit that changed these two in the commit log would
> be nice. Something like:
>
> 	The BT_L2CAP and BT_SCO configs are bool since
>
> 		6427451 (Bluetooth: Merge L2CAP and SCO modules into bluetooth.ko)
>
> 	. So change all defconfigs from =m to =y.
>
> Other than that
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Thanks .
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
