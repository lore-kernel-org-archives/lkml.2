Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0LRKKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 05:10:11 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23817 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0LRKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 05:10:08 -0500
Date: Sat, 18 Dec 2010 11:09:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than 
 hardcoding resources and devices
Message-ID: <20101218110954.7a2ca190@endymion.delvare>
In-Reply-To: <20101218093719.GA1493@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
	<1292624661-32474-1-git-send-email-mjg@redhat.com>
	<20101218042320.GA14104@ericsson.com>
	<20101218093719.GA1493@polaris.bitmath.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 10:37:19 +0100, Henrik Rydberg wrote:
> So where to attach the sysfs nodes... There is also a userspace issue
> here, since a lot of applications are hard-wired to
> /sys/devices/platform/applesmc.768/.

Which applications? libsensors-based applications definitely don't
hard-wire anything.

-- 
Jean Delvare
