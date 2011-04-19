Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1DSPpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:45:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57804 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1DSPpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <201104191707.40456.arnd@arndb.de>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
 <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com> <BANLkTin-qL3ppG1jRjBu3S16SWcNjD=3kA@mail.gmail.com>
 <201104191707.40456.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Apr 2011 09:45:10 -0600
X-Google-Sender-Auth: TS7tr-H73H0w7EPntKw44lTOJEE
Message-ID: <BANLkTim9_n85ahW781fGjf_iofhBjnD36w@mail.gmail.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Williams <john.williams@petalogix.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 9:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 April 2011, Grant Likely wrote:
>> > or whatever, as this would bind all instances matching vendor,device.
>> >
>> > So, the question I have is, how to handle bind per-instance?
>>
>> By manipulating a property on the device instance of course!  :-)
>>
>> Something like:  echo "generic-uio" >>
>> /sys/devices/path/to/device/a-property-that-changes-the-driver-it-will-bind-to.
>>
>
> But what code would create that in sysfs, and based on what properties
> of the device? Should we do that for every platform device, or perhaps
> for every one that has any resources?

Yes, I think it can be a generic facility for all platform_devices.
We already have some code to support user-space manipulated driver
binding/unbinding.  This is very much in the same vein.

g.
