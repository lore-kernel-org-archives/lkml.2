Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1D0AyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:54:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60991 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1D0AyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LxBwY5YWw2ayCIhL9fa++1TjtnpJ2KC9Tb6/pi8ZtCbUhWaCqZ4fS2onGYtmlKK/+C
         RPQbIJA5fHB/5a2aOM+Znw09PfG159WxSODIoSCGecitinhzEACzg8679j6g8pscQEZn
         6qrr2nI+O9FbE3kg8ot4Scytx+woe3dP2UMPM=
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 20:54:07 -0400
Message-ID: <BANLkTinQJ6wzOR++c-OSiCkf=MjOU=y=1A@mail.gmail.com>
Subject: How to export information larger than PROC_BLOCK_SIZE via /proc file system?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am tracing some data inside the kernel, and I plan to export the
tracing data through /proc file system. I created a file under /proc
file system, and I use cat to display the tracing data. However, every
time there is only 3072 bytes data displayed, which is the size
defined by PROC_BLOCK_SIZE. And I wonder that how to export
information more than that limit? Judging from the function
fs/proc/generic.c/proc_file_read(), if the size returned by my
read_proc function is large than a PAGE_SIZE, then I will get a
KERN_ERR message which says "proc_file_read: Apparent buffer
overflow!". Any help would be appreciated!

Regards
Jidong
