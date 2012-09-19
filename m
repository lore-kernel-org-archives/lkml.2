Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2ISIcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:32:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1823 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2ISIcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:32:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 19 Sep 2012 01:32:09 -0700
From: Jim Lin <jilin@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2012 16:32:37 +0800
Subject: RE: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
Thread-Topic: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
Thread-Index: Ac2WPZVs6k/+UKKjRqm5knwkAXUxzwAAdLbg
Message-ID: <4B9C9637D5087840A465BDCB251780E9E2D8499019@HKMAIL02.nvidia.com>
References: <1348026530-17327-1-git-send-email-jilin@nvidia.com>
 <20120919062927.GB15492@kroah.com> <1348041222.20200.20.camel@jilin-desktop>
 <20120919080412.GA18986@kroah.com>
In-Reply-To: <20120919080412.GA18986@kroah.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Greg KH [mailto:gregkh@linuxfoundation.org] 
>Sent: Wednesday, September 19, 2012 4:04 PM
>To: Jim Lin
>Cc: swarren@wwwdotorg.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH v2 1/1] USB: EHCI: Tegra: Fix wrong register definition
>
>On Wed, Sep 19, 2012 at 03:53:42PM +0800, Jim Lin wrote:
>> On Wed, 2012-09-19 at 14:29 +0800, Greg KH wrote:
>> > On Wed, Sep 19, 2012 at 11:48:50AM +0800, Jim Lin wrote:
> > > Fix the issue that EHCI registers, hostpc[0] and usbmode_ex, are 
>> > > not correctly accessed on Tegra3 platform.
>> > > 
>> > > Signed-off-by: Jim Lin <jilin@nvidia.com>
>> > > ---
>> > > Changes in v2:
>> > > - Modify array size for reserved4[] only.
>> > > - Note that defining hostpc[0] is for a variable-length object.
>> > 
>> > Didn't I already apply V1 of this patch?  Can you now send me a 
>> > fixup given that the first patch had a problem?
>> > 
>> > thanks,
>> > 
>> > greg k-h
>> If you have applied v1, that's fine.
>
>You should have gotten an email from me saying I applied it, did that not go through properly?
>
>thanks,
>
>greg k-h
Sorry, my mistake, I received that mail and thought still having chance to fine tune.

--
nvpublic
