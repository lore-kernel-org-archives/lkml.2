Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1CMPKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:10:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63363 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1CMPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XxZHuW0pj8/Z4otamEJfqxulOwKIVFbncHt5Xqw9kjDH/rQXgX7wzuLtQZki3E3NSO
         oJ9/IDBouJPmCnEp09rzjYZgP3hxhVPz3PU7auG62xMZYcbJw3QxKmA7mNxqelL/r3JK
         SGjzXM2sVfgFPSBB+a1GZ1FHSuDAvuqwkb97M=
MIME-Version: 1.0
Date: Sun, 13 Mar 2011 18:10:22 +0300
Message-ID: <AANLkTi=OK1U10i7_07PkCZc2zgno-jpEaqYMa+9eWY1W@mail.gmail.com>
Subject: Something like POSIX_FADV_DONTNEED for metadata needed
From: John Lepikhin <johnlepikhin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to read a huge number of directories listings without resetting
the current buffers. Is there some kind of analogue of the flag
POSIX_FADV_DONTNEED to prohibit caching inodes and directory listing?


Thank you.
