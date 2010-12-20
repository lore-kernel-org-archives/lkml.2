Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0LTOUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:20:08 -0500
Received: from mail12.space2u.com ([194.237.215.104]:48703 "EHLO
	mail12.space2u.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0LTOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:20:06 -0500
X-Greylist: delayed 2082 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 09:20:06 EST
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
From: Mikael =?ISO-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Julien BLACHE <jb@jblache.org>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20101218115742.GA2063@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
	 <1292624661-32474-1-git-send-email-mjg@redhat.com>
	 <20101218042320.GA14104@ericsson.com>
	 <20101218093719.GA1493@polaris.bitmath.org>
	 <20101218110954.7a2ca190@endymion.delvare>
	 <20101218103139.GA1668@polaris.bitmath.org>
	 <878vzngvyn.fsf@sonic.technologeek.org>
	 <20101218115742.GA2063@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 21:44:34 +0800
Message-ID: <1292852674.2118.10.camel@mike-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know nothing about the background to the mail below, but if it's of
any help, macfanctld uses the following hardwired paths,

reading:

/sys/devices/platform/applesmc.768/temp<n>_input

and writing:

/sys/devices/platform/applesmc.768/fan1_min
/sys/devices/platform/applesmc.768/fan2_min
/sys/devices/platform/applesmc.768/fan1_manual
/sys/devices/platform/applesmc.768/fan2_manual

If any of those are to be broken, please advice in advance so i can
update the source before you break it, avoiding that the users fry their
MacBooks.

Thanks,
Mike

-- 
Mikael Ström <mikael@sesamiq.com>

On Sat, 2010-12-18 at 12:57 +0100, Henrik Rydberg wrote:
> On Sat, Dec 18, 2010 at 12:29:52PM +0100, Julien BLACHE wrote:
> > "Henrik Rydberg" <rydberg@euromail.se> wrote:
> > 
> > Hi,
> > 
> > >> Which applications? libsensors-based applications definitely don't
> > >> hard-wire anything.
> > >
> > > The ones I am thinking of are pommed and macfanctld, there are
> > > probably others. The sysfs nodes have been around a while, so it is
> > > not really surprising. If there is a policy saying it is ok to break
> > > userspace in this case, that's fine.
> > 
> > I've just changed pommed to probe for applesmc through /sys/class/hwmon,
> > so you can go ahead and break it as far as I'm concerned :)
> 
> Great, thanks Julien. And macfanctld should not be a problem either (ccing the author).
> 
> Henrik
> 

