Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2GKJyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:54:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36548 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2GKJyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FFD20F3.2020303@odi.ch>
References: <4FFBFF93.7030201@odi.ch>
	<20120710162846.3c0f8ed7@pyramind.ukuu.org.uk>
	<4FFD20F3.2020303@odi.ch>
Date: Wed, 11 Jul 2012 12:54:04 +0300
X-Google-Sender-Auth: UUYf5SN1_e1LewGOPd1B-QycuPk
Message-ID: <CA+i0qc5Eh8t07k+uAF-S9VmL6bxQSL4DbvZqHq6ZZ6XxB=1ZXg@mail.gmail.com>
Subject: Re: [PATCH] mei: module version
From: Tomas Winkler <tomas.winkler@intel.com>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 9:45 AM, Ortwin Glück <odi@odi.ch> wrote:
>
> On 07/10/2012 05:28 PM, Alan Cox wrote:
>>
>> On Tue, 10 Jul 2012 12:10:27 +0200
>> Ortwin Glück<odi@odi.ch>  wrote:
>>
>>> The LMS daemon expects a /sys/modules/mei/version file with, a four
>>> digit version number.
>>>
>>> see
>>>
>>> http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
>>
>>
>> Just get them to fix the userspace. I thought the latest one had this
>> dealt with ?
>>
>
> You are right of course.
>
> I thought the code at that URL is the latest one. At least the URL claims
> to be :-) Admitted, the code doesn't even build without a minor include fix.
> Has anyone got pointers to more recent code? We are trying to get it into
> Gentoo: https://bugs.gentoo.org/show_bug.cgi?id=425658 and I woud like to
> have the patches upstream.
>
The new version of LMS with this fixed  is in validation stage and
will be released soon

Thanks
Tomas
