Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0LPQtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:49:41 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49259 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab0LPQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:49:40 -0500
Message-ID: <4D0A42CE.7030000@euromail.se>
Date: Thu, 16 Dec 2010 17:48:14 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 1/2] applesmc: Use PnP rather than hardcoding resources
 and devices
References: <1292513589-14651-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1292513589-14651-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTH0W-0000Uy-9h.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PTH0W-0000Uy-9h cb83bf772f2333697c963cb93b113c8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> The AppleSMC device is described in ACPI, including a list of its resources.

> We should use those rather than hardcoding the ports. A side-effect is that
> we can then remove the DMI matching, since there's a unique identifier to
> indicate that the machine has one of these devices.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>


Thank you very much for these patches. Unfortunately, they do not quite apply in
this end. If you could please rebase to linux-next [1], that would be great.

Thanks,
Henrik

[1] You find the same version in Guenther's tree or in
git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/hwmon.git, if that is more
convenient.
