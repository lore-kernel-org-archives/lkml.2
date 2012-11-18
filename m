Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2KROGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:06:33 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34061 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2KROGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:06:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121118034117.GA2604@kroah.com>
References: <CACnwZYdSW5=MLBrOC_cD7b3AB_PcQeyjR=JPJnfPCzJapZbGEw@mail.gmail.com>
	<20121118034117.GA2604@kroah.com>
Date: Sun, 18 Nov 2012 12:06:31 -0200
Message-ID: <CACnwZYcbaTbRX7_tv5x1yPNbPwPkp4nT=upBCatYEgp0YESYYw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IGRyaXZlcnMvdXNiL3VzYi1za2VsZXRvbi5jOjExNzozOiBlcnJvcjogbGFiZWwg?=
	=?UTF-8?B?4oCYb3V0X2VycuKAmSB1c2VkIGJ1dCBub3QgZGVmaW5l?=
From: Thiago Farina <tfransosi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux list <linux-kernel@vger.kernel.org>, tom.leiming@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 1:41 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> If not, what would be the right fix?
>
> Properly define out_err.
>
> I thought this all got fixed up recently, what kernel version are you
> looking at?
>
That might explain why I'm seeing this.

Because I'm building the kernel I checked out from
git://github.com/torvalds/linux.git, currently at commit f4a75d2e
(Linux 3.7-rc6).
