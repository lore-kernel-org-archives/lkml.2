Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0LRKch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 05:32:37 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:36902 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598Ab0LRKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 05:32:35 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 11:31:39 +0100
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
Message-ID: <20101218103139.GA1668@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
 <20101218093719.GA1493@polaris.bitmath.org>
 <20101218110954.7a2ca190@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218110954.7a2ca190@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTu4j-0004N6-5W.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTu4j-0004N6-5W 4c966ffbb767e8c2f4ff45a9f96e917f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 11:09:54AM +0100, Jean Delvare wrote:
> On Sat, 18 Dec 2010 10:37:19 +0100, Henrik Rydberg wrote:
> > So where to attach the sysfs nodes... There is also a userspace issue
> > here, since a lot of applications are hard-wired to
> > /sys/devices/platform/applesmc.768/.
> 
> Which applications? libsensors-based applications definitely don't
> hard-wire anything.

The ones I am thinking of are pommed and macfanctld, there are
probably others. The sysfs nodes have been around a while, so it is
not really surprising. If there is a policy saying it is ok to break
userspace in this case, that's fine.

Henrik
