Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2LJOUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:20:18 -0500
Received: from void.printf.net ([89.145.121.20]:40371 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab2LJOUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:20:16 -0500
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: sdhci-acpi: enable runtime-pm for device HID INT33C6
References: <1355130644-26065-1-git-send-email-adrian.hunter@intel.com>
	<1355130644-26065-2-git-send-email-adrian.hunter@intel.com>
Date: Mon, 10 Dec 2012 09:20:03 -0500
In-Reply-To: <1355130644-26065-2-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 10 Dec 2012 11:10:44 +0200")
Message-ID: <87a9tm56r0.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 10 2012, Adrian Hunter wrote:
> sdhci-acpi supports ACPI devices which have compatibility ID
> PNP0D40, however it is not possible to know if those devices
> will all work correctly with runtime-pm, so that must be configured
> per hardware ID.

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
