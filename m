Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2HVX61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:58:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18973 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2HVX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:58:24 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-a0-5035721e19c2
Message-id: <5035721D.6080404@samsung.com>
Date: Thu, 23 Aug 2012 08:58:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org
Subject: Re: [PATCH RESEND] extcon: fix typos in sys-class-extcon
References: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
In-reply-to: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAV25ItMAgwdfLCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/A2KBe+lK65MUm5g7BLrYuTkkBAwkTj26gobhC0mceHeeiCb
	i0NIYBGjxOWTD1hAEkICXUwS3RtVQWxeAS2Ja9Mms4LYLAKqEs3rJ4A1swHF97+4AWRzcIgK
	REj86ueAKBeU+DH5HgtIWETAR+LQo1KQMLNAqcSjfReYQMLCAo4SV1uTQEwhAQeJZXckQCo4
	gaKvVh1nhajWkdjfOo0NwpaX2LzmLfMERoFZSObPQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBQfdMagfjygaLQ4wCHIxKPLwZsaYBQqyJZcWVuYcYJTiYlUR4bxgAhXhT
	EiurUovy44tKc1KLDzFKc7AoifPy9xkGCAmkJ5akZqemFqQWwWSZODilGhiDkvnkpqRbpdvK
	TP4pdeSs+C9Bs2czfBbzyjyoP6N8/6flnnPmbre9flkahPNyKsy9EGzwXUjltdYUNdYHB3ed
	XRg+u3WZdJpBf/ihFZLxi203/apyCdHn4C1b+JRn6pdsE+bZ7IyOkRbzZy07mKbEHG/LqHhc
	57nHHmf+hKSmUyq7OSddf6zEUpyRaKjFXFScCADcUaEcNgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:27 AM, Peter Meerwald wrote:

> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
> ---
>  Documentation/ABI/testing/sysfs-class-extcon |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
> index 20ab361..57a7262 100644
> --- a/Documentation/ABI/testing/sysfs-class-extcon
> +++ b/Documentation/ABI/testing/sysfs-class-extcon
> @@ -13,7 +13,7 @@ Description:
>  		accessory cables have such capability. For example,
>  		the 30-pin port of Nuri board (/arch/arm/mach-exynos)
>  		may have both HDMI and Charger attached, or analog audio,
> -		video, and USB cables attached simulteneously.
> +		video, and USB cables attached simultaneously.
>  
>  		If there are cables mutually exclusive with each other,
>  		such binary relations may be expressed with extcon_dev's
> @@ -35,7 +35,7 @@ Description:
>  		The /sys/class/extcon/.../state shows and stores the cable
>  		attach/detach information of the corresponding extcon object.
>  		If the extcon object has an optional callback "show_state"
> -		defined, the showing function is overriden with the optional
> +		defined, the showing function is overridden with the optional
>  		callback.
>  
>  		If the default callback for showing function is used, the
> @@ -46,19 +46,19 @@ Description:
>  		TA=1
>  		EAR_JACK=0
>  		#
> -		In this example, the extcon device have USB_OTG and TA
> +		In this example, the extcon device has USB_OTG and TA
>  		cables attached and HDMI and EAR_JACK cables detached.
>  
>  		In order to update the state of an extcon device, enter a hex
> -		state number starting with 0x.
> -		 echo 0xHEX > state
> +		state number starting with 0x:
> +		# echo 0xHEX > state
>  
> -		This updates the whole state of the extcon dev.
> +		This updates the whole state of the extcon device.
>  		Inputs of all the methods are required to meet the
> -		mutually_exclusive contidions if they exist.
> +		mutually_exclusive conditions if they exist.
>  
>  		It is recommended to use this "global" state interface if
> -		you need to enter the value atomically. The later state
> +		you need to set the value atomically. The later state
>  		interface associated with each cable cannot update
>  		multiple cable states of an extcon device simultaneously.
>  
> @@ -73,7 +73,7 @@ What:		/sys/class/extcon/.../cable.x/state
>  Date:		February 2012
>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>  Description:
> -		The /sys/class/extcon/.../cable.x/name shows and stores the
> +		The /sys/class/extcon/.../cable.x/state shows and stores the
>  		state of cable "x" (integer between 0 and 31) of an extcon
>  		device. The state value is either 0 (detached) or 1
>  		(attached).
> @@ -83,8 +83,8 @@ Date:		December 2011
>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>  Description:
>  		Shows the relations of mutually exclusiveness. For example,
> -		if the mutually_exclusive array of extcon_dev is
> -		{0x3, 0x5, 0xC, 0x0}, the, the output is:
> +		if the mutually_exclusive array of extcon device is
> +		{0x3, 0x5, 0xC, 0x0}, then the output is:
>  		# ls mutually_exclusive/
>  		0x3
>  		0x5


Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I will apply this patch to
http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next
and you can check it after some hours.

Thank you
Chanwoo Choi

