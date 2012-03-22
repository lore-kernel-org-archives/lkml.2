Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2CVRzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:55:44 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:51139 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2CVRzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:55:42 -0400
Message-ID: <4F6B679C.60004@yahoo.co.jp>
Date: Fri, 23 Mar 2012 02:55:40 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com>
In-Reply-To: <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

Thank you for your information.
I think ata8 might different from other 3 PMPs. I'll try to update all
firmware but it is running resync on broken RAID now. So I can't do it soon.
By the way, both of ata8 and ata9 loses some HDDs also. Are those
affected by PMPs on ata7 and ata10? Why 3.1.x driver can work?

Best Regards,
Akira

> Now I see your problem. Indeed on ata7, ata10, we have a problem.
> I notice however some messages I did not see before:
>>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>> [    4.858742] ata7.00: hard resetting link
>>> [   14.843039] ata7.00: softreset failed (timeout)
>>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
> The later indicates that the PMP is stuck and the host can not read
> its internal register.
> Is it possible that the PMP in these 4 enclosures you are using have a
> different firmware than the other ones?
> Firmware 1.0114 is available at:
> http://www.siliconimage.com/support/searchresults.aspx?pid=26&cat=23
> 
> From the release notes:
> """- Fix SRST and initial two RegFIS Problem."""
> 
> Gwendal.

