Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2GKGpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:45:14 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:39537 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab2GKGpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:45:12 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <4FFD20F3.2020303@odi.ch>
Date: Wed, 11 Jul 2012 08:45:07 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mei: module version
References: <4FFBFF93.7030201@odi.ch> <20120710162846.3c0f8ed7@pyramind.ukuu.org.uk>
In-Reply-To: <20120710162846.3c0f8ed7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 05:28 PM, Alan Cox wrote:
> On Tue, 10 Jul 2012 12:10:27 +0200
> Ortwin Glück<odi@odi.ch>  wrote:
>
>> The LMS daemon expects a /sys/modules/mei/version file with, a four
>> digit version number.
>>
>> see
>> http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
>
> Just get them to fix the userspace. I thought the latest one had this
> dealt with ?
>

You are right of course.

I thought the code at that URL is the latest one. At least the URL claims to be 
:-) Admitted, the code doesn't even build without a minor include fix. Has 
anyone got pointers to more recent code? We are trying to get it into Gentoo: 
https://bugs.gentoo.org/show_bug.cgi?id=425658 and I woud like to have the 
patches upstream.
