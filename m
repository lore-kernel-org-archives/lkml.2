Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab0ILHLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 03:11:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62461 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0ILHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 03:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LlKyoEW1Lt8J3pqAQQRa41D4rz3o1FdXwgdFgONglHDkDGAC0VOXX5b5RwhKOJ4uXs
         dj9JnRq9R8dqczci4T2cjtLTjzIZSZL07z6WgA9DBstrxyC8w+MvgMz0wT17U0sG2rzI
         ZXqnvtXh+hyRArE/TLqYxx/tyJoO7H6iZAoQ4=
MIME-Version: 1.0
Date: Sun, 12 Sep 2010 03:11:09 -0400
Message-ID: <AANLkTimtCj4iH8uZx_Kbv6p1x+3GGAg2zNowZOHYnk+k@mail.gmail.com>
Subject: tcp_recvmsg question
From: Mihail Ionescu <bucalelinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a research project, where I try to intercept the
incoming tcp packets going to a specific process. I use the 2.6.24.5
kernel version.

I tried to find out how the data is copied to the user level pointer
in the tcp_recvmsg function, but I could not find anything. I disabled
CONFIG_NET_DMA. I was assuming that, before the function finishes, the
data to be transferred to the user space is located at
msg->msg_iov->iov_base. I tried to copy this data to a kernel buffer
using copy_from_user, just before the tcp_recvmsg finishes, but the
data copied is not the same as the one which gets to the user
application. Any ideas how to get the data that is sent to the user at
this level?

Thanks,

Mihail
