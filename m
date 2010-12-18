Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0LRLi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 06:38:57 -0500
Received: from ix.technologeek.org ([213.41.157.215]:54664 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755249Ab0LRLi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 06:38:56 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2010 06:38:55 EST
From: Julien BLACHE <jb@jblache.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors\@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding resources and devices
References: <20101217221618.GA13207@ericsson.com>
	<1292624661-32474-1-git-send-email-mjg@redhat.com>
	<20101218042320.GA14104@ericsson.com>
	<20101218093719.GA1493@polaris.bitmath.org>
	<20101218110954.7a2ca190@endymion.delvare>
	<20101218103139.GA1668@polaris.bitmath.org>
Date: Sat, 18 Dec 2010 12:29:52 +0100
In-Reply-To: <20101218103139.GA1668@polaris.bitmath.org> (Henrik Rydberg's
	message of "Sat, 18 Dec 2010 11:31:39 +0100")
Message-ID: <878vzngvyn.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Henrik Rydberg" <rydberg@euromail.se> wrote:

Hi,

>> Which applications? libsensors-based applications definitely don't
>> hard-wire anything.
>
> The ones I am thinking of are pommed and macfanctld, there are
> probably others. The sysfs nodes have been around a while, so it is
> not really surprising. If there is a policy saying it is ok to break
> userspace in this case, that's fine.

I've just changed pommed to probe for applesmc through /sys/class/hwmon,
so you can go ahead and break it as far as I'm concerned :)

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
