Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1HGRJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:09:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44098 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1HGRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:09:33 -0400
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Sun, 7 Aug 2011 21:39:12 +0430
Message-ID: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
Subject: Compile kernel for various times and problem of too long time consuming
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Since I want to evaluate performance improvements by changing just one
file in kernel(noop-iosched) and compiling kernel is too much
time-consuming, I want to know that if I compile kernel for more than
one time, does it take similar time to first time?

I use following commands. If I don't use "make-kpkg clean" for next
times, does it just compile the files which have been modified or it
compile whole kernel package again?

make-kpkg clean
fakeroot make-kpkg --initrd --append-to-version=-some-string-here
kernel-image kernel-headers


Thanks for your help in advance,

--
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
