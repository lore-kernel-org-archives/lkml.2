Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0LULJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:09:23 -0500
Received: from ix.technologeek.org ([213.41.157.215]:42964 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058Ab0LULJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:09:21 -0500
From: Julien BLACHE <jb@jblache.org>
To: Mikael =?iso-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors\@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding resources and devices
References: <20101217221618.GA13207@ericsson.com>
	<1292624661-32474-1-git-send-email-mjg@redhat.com>
	<20101218042320.GA14104@ericsson.com>
	<20101218093719.GA1493@polaris.bitmath.org>
	<20101218110954.7a2ca190@endymion.delvare>
	<20101218103139.GA1668@polaris.bitmath.org>
	<878vzngvyn.fsf@sonic.technologeek.org>
	<20101218115742.GA2063@polaris.bitmath.org>
	<1292852674.2118.10.camel@mike-laptop>
	<20101220140032.GA23257@srcf.ucam.org>
	<1292911480.2316.43.camel@mike-laptop>
Date: Tue, 21 Dec 2010 12:09:18 +0100
In-Reply-To: <1292911480.2316.43.camel@mike-laptop> ("Mikael
 =?iso-8859-1?Q?Str=F6m=22's?= message
	of "Tue, 21 Dec 2010 14:04:40 +0800")
Message-ID: <8762unfkm9.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Ström <mikael@sesamiq.com> wrote:

Hi,

> Before i start to work on that, please confirm that i got this right:
>
> In /sys/class/hwmon/hwmon<0..n>/device, locate fan<1..2>_* for
> controlling the fan(s).
>
> In /sys/class/hwmon/hwmon<0..n>/device, locate temp<1..n>_* for
> enumerating and reading the temp sensors.

Check that device/name is "applesmc", it's faster, simpler and a lot
safer. See the last commit on pommed if you want to borrow some code.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
