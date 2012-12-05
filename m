Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2LESXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:23:32 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55470 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2LESXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:23:30 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
In-Reply-To: <20121205181353.GA2042@kroah.com>
References: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
 <20121126183538.GA18590@kroah.com> <CACaajQsqKDNkMQ6+1bPNgVf6A7DAfC1ZiMBVwQKODHnq2yS-OA@mail.gmail.com>
 <20121205181353.GA2042@kroah.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Wed, 5 Dec 2012 22:23:13 +0400
X-Google-Sender-Auth: JTIGv2zrmQGUXPi9kZPm19_Xn1Y
Message-ID: <CACaajQs1es2iS0aeH-QT0OXHdw1XQsb1_nF_9SH24t+vaja3xg@mail.gmail.com>
Subject: Re: sles 11 sp2 srp and multipath issues
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, i'm try latest 3.6 and send results.

2012/12/5 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Dec 05, 2012 at 10:06:45PM +0400, Vasiliy Tolstov wrote:
>> 2012/11/26 Greg KH <gregkh@linuxfoundation.org>:
>> >
>> > If you use a kernel.org released kernel, then we can help you out.
>> >
>> > Best of luck,
>>
>> Okay. I'm use kernel from you git tree (3.0.53 stable branch). But
>> have no luck. Ahen i'm force reboot storage server multipath -ll on
>> initiator side locked.
>> echo w > /proc/sysrq-trigger says:
>
> 3.0-stable is still quite old, can you duplicate this on the latest 3.6
> kernel?
>
> Also, if you have multipath issues, please cc: the multipath developers,
> they are the ones that can best help you out here.
>
> greg k-h



-- 
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
