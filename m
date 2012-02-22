Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2BVIXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:23:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2BVIXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:23:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.149.162 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120220022729.GJ3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-5-git-send-email-myungjoo.ham@samsung.com>
	<20120220022729.GJ3194@opensource.wolfsonmicro.com>
Date: Wed, 22 Feb 2012 17:23:40 +0900
X-Google-Sender-Auth: sPUSZetdjY3j_lnHGulRd-CQHKU
Message-ID: <CAJ0PZbTRRsyF4tGSYPagVmZQ495bmduYZ+FfPjn=Kp9hhcmhxQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] Extcon: support mutually exclusive relation
 between cables.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:27 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Feb 10, 2012 at 03:40:37PM +0900, MyungJoo Ham wrote:
>
>> +What:                /sys/class/extcon/.../mutually_exclusive
>> +Date:                December 2011
>> +Contact:     MyungJoo Ham <myungjoo.ham@samsung.com>
>> +Description:
>> +             Shows the relations of mutually exclusiveness. For example,
>> +             if the mutually_exclusive array of extcon_dev is
>> +             {0x3, 0x5, 0xC, 0x0}, the, the output is:
>> +             # cat mutually_exclusive
>> +             0x3
>> +             0x5
>> +             0xC
>> +             #
>
> sysfs really isn't supposed to have more than one value per file so this
> should be something like a directory with one array element per file.
> It'd kind of be cheating but the values could be used as the filenames,
> though serial numbers would be more idiomatic.

Hmm.. I'll either use multiple files with a sub-directory or bin-attr
to inhabit the values. Or I'll search for any other convinient way to
express such an array thru sysfs.

Thanks.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab,S/W Center, Samsung Electronics
