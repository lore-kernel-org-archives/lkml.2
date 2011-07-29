Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1G2Ctb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 22:49:31 -0400
Received: from void.printf.net ([89.145.121.20]:52959 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab1G2Cta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 22:49:30 -0400
From: Chris Ball <cjb@laptop.org>
To: matsumur@nts.ricoh.co.jp
Cc: ak@linux.intel.com, Andi Kleen <andi@firstfloor.org>,
        daniel.manrique@canonical.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, manoj.iyer@canonical.com,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
References: <OF5CBC52FF.5B5957D9-ON492578DC.00093451-492578DC.000BCC8B@mta.ricoh.co.jp>
Date: Thu, 28 Jul 2011 22:49:20 -0400
In-Reply-To: <OF5CBC52FF.5B5957D9-ON492578DC.00093451-492578DC.000BCC8B@mta.ricoh.co.jp>
	(matsumur@nts.ricoh.co.jp's message of "Fri, 29 Jul 2011 11:10:45
	+0900")
Message-ID: <m2ipqldcnj.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 28 2011, matsumur@nts.ricoh.co.jp wrote:
> As you know, SD ver.1.1 and 2.0(SDHC) cards can be applied 50MHz SD-CLK..
> SD 3.0 (UHS-I) cards also can be applied 50Mhz. However UHS-I cards are
> available 200 or 100Mhz SD-CLK.
> I would like to know if the current SD Host driver has the function of
> setting SD-CLK to 200Mhz for SD ver3.0 compliant Host Controller.

Yes, we normally would set the higher clock rates for SDv3 controllers.
We are only restricting to 50MHz on this Ricoh 0xe823 controller.

We added support for the SDR104 UHS-1 speeds in Linux 3.0, thanks to
a patchset from Arindam Nath.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
