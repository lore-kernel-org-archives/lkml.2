Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0LREYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 23:24:16 -0500
Received: from imr4.ericy.com ([198.24.6.8]:41661 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab0LREYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 23:24:15 -0500
Date: Fri, 17 Dec 2010 20:23:21 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
 resources and devices
Message-ID: <20101218042320.GA14104@ericsson.com>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1292624661-32474-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:24:20PM -0500, Matthew Garrett wrote:
> The AppleSMC device is described in ACPI, including a list of its resources.
> We should use those rather than hardcoding the ports. A side-effect is that
> we can then remove the DMI matching, since there's a unique identifier to
> indicate that the machine has one of these devices.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

You added a whitespace error, and kfree() is safe and doesn't need a check.
I fixed those, so no need to resubmit. If Henrik gives his Ack we are ready to go.

Guenter
