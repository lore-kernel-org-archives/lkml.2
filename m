Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2GZCvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:51:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57560 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2GZCvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120725184302.GP3099@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FDA9E@DQHE02.ent.ti.com>
 <1342799346.5138.7.camel@lorien2> <CAK5ve-JPtHkCMPV_UYUUZxrt_gzS3tsRXm5x8nFbB6hp+-gBxg@mail.gmail.com>
 <20120722181956.GA4557@opensource.wolfsonmicro.com> <CAK5ve-KAufV5h93AcWdVUVZx2E+pfgQ1L0jp5H28wHgBfV2zPA@mail.gmail.com>
 <20120724125513.GG12438@opensource.wolfsonmicro.com> <CAK5ve-Lyk_EjOjSKHF-j0J1_8oey8wWKkVXAdqbKpRX2eZY+hg@mail.gmail.com>
 <20120725184302.GP3099@opensource.wolfsonmicro.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 26 Jul 2012 10:51:18 +0800
X-Google-Sender-Auth: pSNrGxBqKhBRRyb-_xBHqRPVEiQ
Message-ID: <CAK5ve-JYu9x_pnO2L2R-5933B-TJD4yWukkL9dJYpDLO6+i0Ug@mail.gmail.com>
Subject: Re: [PATCH v2] leds: add new lp8788 led driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: shuahkhan@gmail.com, "Kim, Milo" <Milo.Kim@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 2:43 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jul 25, 2012 at 12:46:56PM +0800, Bryan Wu wrote:
>
>> I'm going to Ack this driver and Mark will you merge this as whole patchset?
>
>> Acked-by: Bryan Wu <bryan.wu@canonical.com>
>
> It's an MFD so Samuel would normally apply if it were going via the MFD
> tree, though if the dependencies are correct there should be no harm
> merging via LEDs (until the core is merged it won't be possible to
> enable the build in Kconfig).

OK, thanks, I've merge this patch through my tree and can I add your ack to it?

-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
