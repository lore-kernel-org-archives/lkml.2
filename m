Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1DJPwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:52:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40768 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1DJPw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UR/7IS3+aR7MNZbvew+fNlRsor+mnnNLxmPt6eQj82udgpR75Zhp96Ye8vbsbOyST8
         yD1xY/u9cGMH/HoOoZdzBYrnw6dchQFDvJ68aodEcBWgEBaJasT+HKiEagNBk8CUEim6
         /u+HEx3mGmlbFCE6mQCBoa92/Ak4gF0GYgthY=
MIME-Version: 1.0
In-Reply-To: <20110408220157.GC26019@kroah.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	<20110408220157.GC26019@kroah.com>
Date: Sun, 10 Apr 2011 17:52:27 +0200
Message-ID: <BANLkTinZbw=GvkThyjMHbeQQ5arRVf2FUg@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/9 Greg KH <greg@kroah.com>:
> On Fri, Apr 08, 2011 at 09:45:00PM +0200, Rafał Miłecki wrote:
>> TODO:
>> - Interrupts
>> - Reloading driver
>
> Please add to the TODO list:
>        - Documentation/ABI entries for new sysfs files
>        - proper Kconfig entry documentation for the different options

Could you tell me sth more about this? How am I expected to document this stuff?

Should I create Documentation/ABI/testing/sysfs-bus-axi or what?

Of course you can just point me to some place where I can read about
proper documenting.

-- 
Rafał
