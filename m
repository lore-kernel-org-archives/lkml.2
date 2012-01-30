Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2A3WxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:53:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48928 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2A3Ww7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:52:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kay.sievers@vrfy.org designates 10.50.222.132 as permitted sender) smtp.mail=kay.sievers@vrfy.org
MIME-Version: 1.0
In-Reply-To: <4F27120A.4040106@suse.cz>
References: <4F27120A.4040106@suse.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 30 Jan 2012 23:52:39 +0100
Message-ID: <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
Subject: Re: sysfs regression: wrong link counts
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/30 Jiri Slaby <jslaby@suse.cz>:
> I cannot boot properly with this commit:
> commit 524b6c5b39b931311dfe5a2f5abae2f5c9731676
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Dec 18 20:09:31 2011 -0800
>
>    sysfs: Kill nlink counting.
>
>
> 1) network systemd rule doesn't start network

What does that mean? What's a network systemd rule?

Kay
