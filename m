Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0LRL6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 06:58:18 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36269 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536Ab0LRL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 06:58:17 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 12:57:42 +0100
To: Julien BLACHE <jb@jblache.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Mikael Strom <mikael@sesamiq.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
Message-ID: <20101218115742.GA2063@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
 <20101218093719.GA1493@polaris.bitmath.org>
 <20101218110954.7a2ca190@endymion.delvare>
 <20101218103139.GA1668@polaris.bitmath.org>
 <878vzngvyn.fsf@sonic.technologeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vzngvyn.fsf@sonic.technologeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTvQC-0003h9-8D.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PTvQC-0003h9-8D 37359dc5d9e85970f01ab55086fec377
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:29:52PM +0100, Julien BLACHE wrote:
> "Henrik Rydberg" <rydberg@euromail.se> wrote:
> 
> Hi,
> 
> >> Which applications? libsensors-based applications definitely don't
> >> hard-wire anything.
> >
> > The ones I am thinking of are pommed and macfanctld, there are
> > probably others. The sysfs nodes have been around a while, so it is
> > not really surprising. If there is a policy saying it is ok to break
> > userspace in this case, that's fine.
> 
> I've just changed pommed to probe for applesmc through /sys/class/hwmon,
> so you can go ahead and break it as far as I'm concerned :)

Great, thanks Julien. And macfanctld should not be a problem either (ccing the author).

Henrik

