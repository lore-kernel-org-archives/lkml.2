Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0LRJIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 04:08:16 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35645 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab0LRJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 04:08:06 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 10:07:14 +0100
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
 resources and devices
Message-ID: <20101218090714.GA436@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218042320.GA14104@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTslU-0004J9-7P.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PTslU-0004J9-7P 2821180d1fb204204eba53c6a8c33f76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 08:23:21PM -0800, Guenter Roeck wrote:
> On Fri, Dec 17, 2010 at 05:24:20PM -0500, Matthew Garrett wrote:
> > The AppleSMC device is described in ACPI, including a list of its resources.
> > We should use those rather than hardcoding the ports. A side-effect is that
> > we can then remove the DMI matching, since there's a unique identifier to
> > indicate that the machine has one of these devices.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> You added a whitespace error, and kfree() is safe and doesn't need a check.
> I fixed those, so no need to resubmit. If Henrik gives his Ack we are ready to go.

Thanks, I will give it some testing before doing so. Matthew, did you
test this under EFI boot? Also, NOTIFICATION_KEY does not seem to be
used anywhere.

Henrik
