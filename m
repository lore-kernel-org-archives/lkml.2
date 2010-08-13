Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121Ab0HMJ1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:27:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43956 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761408Ab0HMJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:27:36 -0400
Message-ID: <4C650FFB.7090602@canonical.com>
Date: Fri, 13 Aug 2010 17:27:23 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ideapad-laptop: add new driver
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com> <1281690893.23680.475.camel@localhost>
In-Reply-To: <1281690893.23680.475.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 05:14 PM, David Woodhouse wrote:
> 
> Hm, interesting. What model (and BIOS version) are you testing with?
I have two machine, B550 and S10-3, the BIOS date/version of S10-3 is the
same with you.

> 
> On my S10-3, (DMI BIOS version 2ACN23WW, date 03/12/2010), I get these
> keys through the normal keyboard controller -- and we can tell the
> brightness up/down apart, too.
> 
> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=9cd075e3
> 
> Do you see those keycodes too... and do they *stop* arriving through the
> keyboard controller when you load your driver?
> 
Yes, IIRC EC will send i8042 keycode when you booting with QS button, not
with power button. atkbd.c reports unknown key after booting with QS button.

