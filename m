Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2G0Tix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:38:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43157 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2G0Tiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120727155027.GA535@kroah.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
	<20120727155027.GA535@kroah.com>
Date: Fri, 27 Jul 2012 12:38:50 -0700
X-Google-Sender-Auth: oF3EyZtR3aWNkuX4YVhYWa0KxK0
Message-ID: <CAMbhsRQvmQv+PjsY0r5B5vDpkAL1KAbN7MKL7mSFFvq_zRhqJQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] add new API to sysfs and device core code
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, hmh@hmh.eng.br, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 8:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 27, 2012 at 12:02:40PM +0800, Bryan Wu wrote:
>> Send out a uevent when create file in sysfs, which is required by userspace
>> application such udev in Android
>
> There is no such thing as "udev in Android" the last time I looked.
>
> Has this changed?

Android does not use udev, but it does have a daemon that listens for
uevents (ueventd).  I used udev in my previous examples because the
issue is not specific to Android.
