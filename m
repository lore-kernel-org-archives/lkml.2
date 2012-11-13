Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2KMXTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:19:09 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33002 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2KMXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:19:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121113230236.GA25569@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
	<20121113190123.GA32271@kroah.com>
	<CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
	<20121113230236.GA25569@kroah.com>
Date: Wed, 14 Nov 2012 01:19:06 +0200
X-Google-Sender-Auth: aCQaJSRkXuY7u2RqlL32BuBkIXg
Message-ID: <CAE7jHC9EU=1VWG+quFZw=9b9GTh+TLzCQQvpS0qMKXNznVZZYA@mail.gmail.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 1:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 14, 2012 at 12:31:13AM +0200, Constantine Shulyupin wrote:
>> >> + *   Device Model (class, device)
>> > Don't use class code in an example, it is slowly going away from the
>> > whole kernel.
>> What to use instead class_create and device_create?
>
> What are you trying to do?

I trying to properly register char device and device region.
Single char device could be registered as misc device with just misc_register.
How to register properly char devices region?
Should to use device_register instead device_create to create dev files?
Which other registration functions char device must to call besides
alloc_chrdev_region, cdev_add?
