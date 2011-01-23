Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1AWAO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 19:14:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41816 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1AWAO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 19:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlPZGiNY+ba+wnc5Ypgk7YFFAYqZI8e+QAznubVvYvwHwkazo978/1WNpu9ecuP3xD
         wQrXYF4uK3OhwIG9B9rq8jbilSfm9YJVWZOxiH4GbknCmaEy5glug6z9hkY3LY5jCImr
         4DharMlf1ycQjMn0ey01prT5+Uu6DJbmLtva8=
MIME-Version: 1.0
In-Reply-To: <201101222012.14028.rjw@sisk.pl>
References: <201101201226.41021.rjw@sisk.pl>
	<201101221025.49327.rjw@sisk.pl>
	<AANLkTi=MDyaPj9D+28NWRRK13qhJfKw098xPPhwrGZoa@mail.gmail.com>
	<201101222012.14028.rjw@sisk.pl>
Date: Sun, 23 Jan 2011 08:14:57 +0800
Message-ID: <AANLkTikstr=vY=1S7A4Pudg3u=k4eJ7HRz6tWwAq4N-v@mail.gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 3:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, January 22, 2011, Jeff Chua wrote:
>> 2011/1/22 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Saturday, January 22, 2011, Jeff Chua wrote:
>>
>> > means that my patch [11/11] _and_ the replacement are totally wrong, because you have
>> > _multiple_ NVS regions.  That really helped, thanks a lot.
>>
>> Would it be different if I offline all CPUs before suspending to ram?
>> It seems to help with suspending to disk.
>
> No, that doesn't matter.  NVS regions are just sitting there regardless of
> what happens at run time.

Strange. If I didn't offline, it hanged during suspend even without
thinkpad_acpi. I could see that the suspend code does the offline
automatically, but executing the offline before calling suspend makes
it no hanging.

Jeff
