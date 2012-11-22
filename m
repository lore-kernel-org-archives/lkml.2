Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2KVS6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:31 -0500
Received: from void.printf.net ([89.145.121.20]:43328 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab2KVS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:22 -0500
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add SDHCI ACPI driver
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
Date: Thu, 22 Nov 2012 08:55:45 -0500
In-Reply-To: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 22 Nov 2012 10:43:47 +0200")
Message-ID: <87k3tdagim.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 22 2012, Adrian Hunter wrote:
> Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
> so I suggest Rafael takes the patches with Chris' Ack.
>
> Please note that I would prefer this to be queued for 3.8

Looks fine:

Acked-by: Chris Ball <cjb@laptop.org>

I have some dumb questions, though -- what kind of platforms ship with
these devices?  Do they ever have the controller on PCI too, and what
happens with sdhci-pci vs. sdhci-acpi in that case?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
