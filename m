Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0JLK5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:57:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932158Ab0JLK5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:57:52 -0400
X-Authenticated: #54578410
X-Provags-ID: V01U2FsdGVkX19Qnjt5ZZtQGprC/3SIMLrFwUbaHpRYiY0awrjnyy
	zv3BrtWMZhTSue
Message-ID: <4CB43F2C.4010406@gmx.de>
Date: Tue, 12 Oct 2010 12:57:48 +0200
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Mnenhy/0.8.3 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: select on sysFs-entry does not pend anymore
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *,

on porting a driver from 2.6.29 to 2.6.32 I had to notice that select()
on a sysFs-entry seems not to pend anymore (no more wait for kernel-side
sysfs_notify()). I checked on different architectures (MIPS, PPC, x86),
all the same result :-(
Was this support dropped intentionally or by accident?
The code of sysfs_notify() is still in kernel, but I see no sense in it
if select is not possible.
Any workaround known that is as easy as the original?

Please don't forget to CC me on answers to list, as I haven't subscribed
to this group.

-- 
KR and TIA
Michael
