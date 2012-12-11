Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2LKLq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:46:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54948 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2LKLq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:46:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: sdhci-acpi: enable runtime-pm for device HID INT33C6
Date: Tue, 11 Dec 2012 12:51:58 +0100
Message-ID: <45176674.6KLpGCyqyD@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <87a9tm56r0.fsf@octavius.laptop.org>
References: <1355130644-26065-1-git-send-email-adrian.hunter@intel.com> <1355130644-26065-2-git-send-email-adrian.hunter@intel.com> <87a9tm56r0.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 09:20:03 AM Chris Ball wrote:
> Hi,
> 
> On Mon, Dec 10 2012, Adrian Hunter wrote:
> > sdhci-acpi supports ACPI devices which have compatibility ID
> > PNP0D40, however it is not possible to know if those devices
> > will all work correctly with runtime-pm, so that must be configured
> > per hardware ID.
> 
> Acked-by: Chris Ball <cjb@laptop.org>

Applied.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
