Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2KVSdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:45 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44692 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2KVSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:39 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20121121143553.GB21654@kroah.com>
References: <1353496525-6868-1-git-send-email-myungjoo.ham@samsung.com>
	<20121121143553.GB21654@kroah.com>
Date: Thu, 22 Nov 2012 13:59:15 +0900
X-Google-Sender-Auth: CwtkjlYS2VopRXhodYzztfB3RRI
Message-ID: <CAJ0PZbT57xODkEbiVwvck4CE8hTR-Z3fSpHY=KkeWkf11XUXWA@mail.gmail.com>
Subject: Re: [GIT PULL] extcon fixes for Linux 3.7 rc6
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        kyungmin.park@samsung.com, sachin.kamat@linaro.org,
        khoroshilov@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:35 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 21, 2012 at 08:15:25PM +0900, MyungJoo Ham wrote:
>> The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
>>
>>   Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)
>>
>> are available in the git repository at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-gregkh
>>
[]
>
> It's _really_ late in the release cycle for any new patches that are not
> MAJOR problems.  I don't think any of these meet that rule, do you?  If
> you really need them into 3.7, mark them with the Cc: stable line and
> get them into 3.8-rc1.
>
>> Note to Chanwoo and Sachin:
>> In this pull request, I've added bugfixes only.
>> If you see the for-next branch, you can see that the style fixes and
>> devm_* applications are added for later pull requests.
>
> Note, after tomorrow, I will not be taking any new patches for 3.8-rc1,
> so you better get your -next branch to me soon. :)
>
> thanks,
>
> greg k-h

Yes, they are not major bugfixes, but minor fixes.

Please ignore thisone and use the another pull-request sent minutes
ago for 3.8-rc1, which includes patches in this one as well.

Thank you



Cheers,
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
