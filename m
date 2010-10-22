Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0JVOwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:52:01 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:50187 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152Ab0JVOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:51:59 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 5C9E48854
Message-Id: <E1P9Iy2-0001mY-UA@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: Mapping Inode to File
To: Artur Baruchi <mail.baruchi@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 22 Oct 2010 16:51:37 +0200
References: <fGqN4-2Ns-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artur Baruchi <mail.baruchi@gmail.com> wrote:

> Hi Guys.
> 
> Is there a way to map an Inode number to a File (file path and name)
> in a kernel module ?

Imagine this:

ln /foo/bar/baz /bar/baz/foo
sleep 2147483647 < /foo/bar/baz &
pivot_root /mnt /mnt/asd
chroot /mnt/asd/foo

What is the name you'd assign to that inode?

