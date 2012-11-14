Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057Ab2KNKDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:03:47 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:43268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161008Ab2KNKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:03:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, mathias.nyman@linux.intel.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/3 rev 2] Centralized parsing of ACPI device resources
Date: Wed, 14 Nov 2012 11:08:06 +0100
Message-ID: <2248327.u9oE2tplEW@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121114095232.GN31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <5953163.ZajFIHZXph@vostro.rjw.lan> <20121114095232.GN31759@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2012 11:52:32 AM Mika Westerberg wrote:
> On Tue, Nov 13, 2012 at 09:51:39PM +0100, Rafael J. Wysocki wrote:
> > Updated series, taking the Mika's feedback into account, follows.  There are
> > bug fixes in [1/3], [2/3] is unchanged and the new [3/3] is a replacement, done
> > in a different way because of some ACPICA limitations I didn't realize before.
> 
> I've now tested this series on my ACPI 5 enabled test machine and
> everything works fine - I can see the platform devices and that they have
> the ACPI handle attached.
> 
> For the whole series,
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> (testing has been limited on one ACPI 5 machine, though).

OK, thanks!

> I guess I can start preparing the GPIO/SPI/I2C patches soon ;-)

Yes, please. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
