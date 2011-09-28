Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1I1DK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:10:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54863 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1I1DKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:10:54 -0400
MIME-Version: 1.0
In-Reply-To: <201109272232.06389.rjw@sisk.pl>
References: <20110912171003.GA7939@xanatos>
	<20110926234835.GA9551@xanatos>
	<CAJRGBZxTakHn-BQTrLXsccriGAOERDox0pORMP+vrazzqAA-kQ@mail.gmail.com>
	<201109272232.06389.rjw@sisk.pl>
Date: Tue, 27 Sep 2011 23:10:53 -0400
Message-ID: <CAJRGBZyig5gfyhhPaBZotutvPhQcOi_X2vx82=+pkD8dcseRGA@mail.gmail.com>
Subject: Re: PME via interrupt or SCI mechanism?
From: Luming Yu <luming.yu@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        robert.moore@intel.com, Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, September 27, 2011, Luming Yu wrote:
>> On Tue, Sep 27, 2011 at 7:48 AM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> >
>> > Ok.  Do you have suggestions for any tests I can run or debugging
>> > statements to add?  I'm really not an ACPI expert and I've been
>> > basically fumbling in the dark.
>>
>> The following patch from Shaohua might be useful to help debugging the problem.
>> http://kerneltrap.org/mailarchive/linux-usb/2009/7/30/6251245
>
> You probably don't realize that the patch is neither applicable nor
> relevant any more, but it would be nice to check that before
> recommending it to anyone, don't you think?
>

As long as ACPI is involved in some aspect of the bug, I do believe
the patch I pointed out can point you to some interesting interfaces
in ACPI Linux and CA that could be useful to diagnose this type of
problem. At least it pointed out how things begun :)
