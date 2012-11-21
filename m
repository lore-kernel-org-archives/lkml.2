Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2KUOes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:34:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61397 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2KUOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:34:47 -0500
Date: Wed, 21 Nov 2012 06:35:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, khoroshilov@ispras.ru
Subject: Re: [GIT PULL] extcon fixes for Linux 3.7 rc6
Message-ID: <20121121143553.GB21654@kroah.com>
References: <1353496525-6868-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353496525-6868-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 08:15:25PM +0900, MyungJoo Ham wrote:
> The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
> 
>   Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-gregkh
> 
> Alexey Khoroshilov (1):
>       extcon: arizona: unlock mutex on error path in arizona_micdet()
> 
> Chanwoo Choi (1):
>       extcon: Add missing header file to extcon.h
> 
> Sachin Kamat (3):
>       extcon: Fix return value in extcon-class.c
>       extcon: max8997: Fix incorrect error check and return value
>       extcon: max77693: Fix incorrect error check and return value

It's _really_ late in the release cycle for any new patches that are not
MAJOR problems.  I don't think any of these meet that rule, do you?  If
you really need them into 3.7, mark them with the Cc: stable line and
get them into 3.8-rc1.

> Note to Chanwoo and Sachin:
> In this pull request, I've added bugfixes only.
> If you see the for-next branch, you can see that the style fixes and
> devm_* applications are added for later pull requests.

Note, after tomorrow, I will not be taking any new patches for 3.8-rc1,
so you better get your -next branch to me soon. :)

thanks,

greg k-h
