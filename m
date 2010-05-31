Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0EaQPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:15:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:41725 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab0EaQPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:15:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: "H.S." <hs.samix@gmail.com>
Subject: Re: [PATCH] firewire: core: check for 1394a compliant IRM, fix inaccessibility
 of Sony camcorder
Date: Mon, 31 May 2010 11:14:02 -0400
Message-ID: <hu0jnr$10b$1@dough.gmane.org>
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>	<4C017477.8000008@s5r6.in-berlin.de>	<4C0284E7.3050803@s5r6.in-berlin.de>	<tkrat.740b506673ccbf6d@s5r6.in-berlin.de>	<htu993$60f$1@dough.gmane.org>	<4C02B483.9080802@s5r6.in-berlin.de> <htuebt$l80$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 206-248-129-141.dsl.teksavvy.com
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
In-Reply-To: <htuebt$l80$1@dough.gmane.org>
Cc: linux1394-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.S. wrote:
> 
> I will report back how it goes as soon as I am able to do the experiments.
> 


Well, good news. The patch seems to be worked as you designed.

Compiled the kernel with your patch, rebooted the machine and plugged in
the camcorder to the firewire port. This is what the log said:
May 31 11:06:47 red kernel: [  924.228439] firewire_ohci: isochronous
cycle inconsistent
May 31 11:06:48 red kernel: [  924.821383] firewire_core: created device
fw1: GUID 08004601024aca36, S100
May 31 11:06:48 red kernel: [  924.821396] firewire_core: phy config:
card 0, new root=ffc1, gap_count=5
May 31 11:06:48 red kernel: [  924.833768] firewire_core: IRM is not
1394a compliant, making local node (ffc0) root.
May 31 11:06:48 red kernel: [  924.833777] firewire_core: phy config:
card 0, new root=ffc0, gap_count=5


And that is all it said ever after I captured a footage of some seconds.
I used the following command:
$>  dvgrab -a -f raw -t video-

Then I switched off the camera, and still there were no messages in the log.

So, what is verdict?

Meanwhile, I will continue using this kernel.

Thanks.

-- 

Please reply to this list only. I read this list on its corresponding
newsgroup on gmane.org. Replies sent to my email address are just
filtered to a folder in my mailbox and get periodically deleted without
ever having been read.

