Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab0HLDgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:36:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42338 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0HLDgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i2+2tmG8AwIDGTn6pg23BlBAYWiT2Bv58gYHwjNwMk8S5qejhsIO0N5weJKol3zaG1
         ANKCPBPBS5MF/QoG41tSrQmvM0VfRe0eNYsgeHNQAUeMQLED1Bcuec2NVrWkKNB9hURr
         uf6/36psqZ/+fK9fP19SKyzNVcGDTt/fPcmvQ=
MIME-Version: 1.0
In-Reply-To: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 Aug 2010 23:36:31 -0400
Message-ID: <AANLkTimuLjGo7O1kWXq0XbTns4EV2e5q5o0esNns1BY9@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, nico@fluxnic.net, kernel@wantstofly.org,
        kernel@pengutronix.de, u.kleine-koenig@pengutronix.de,
        kaloz@openwrt.org, khc@pm.waw.pl, tj@kernel.org, gregkh@suse.de,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com,
        ralf@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        yakovenkov@gmail.com, w.sang@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 22:53, Marek Vasut wrote:
> These three platforms didn't properly fill nr_chips in gen_nand registration and
> therefore depended on gen_nand bug fixed by the following patch:

the Blackfin arch has a mailing list ... no need to pick out people

> "mtd: gen_nand: fix support for multiple chips"
>
>  arch/blackfin/mach-bf537/boards/stamp.c   |    1 +
>  arch/blackfin/mach-bf561/boards/acvilon.c |    1 +

looks sane enough to me
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
