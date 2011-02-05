Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1BETuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:50:20 -0500
Received: from ns.gobinjf.be ([213.246.39.118]:45054 "EHLO ik118.ikexpress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab1BETuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:50:19 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 14:50:19 EST
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
From: Jean Gobin <jf@gobinjf.be>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
In-Reply-To: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 14:42:47 -0500
Message-ID: <1296934967.2599.2.camel@jeff-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

When you run the copy over the network, could you issue a "vmstat 1" on
both machines?

Thanks,
J.




On Sat, 2011-02-05 at 14:35 -0500, Justin Piszcz wrote:
> Hi,
> 
> I have two identical X8DTH-6's, each with 5520s XEONS..
> 
> === RAID
> Two 3ware RAID-0's (testing only) with 24 drives (2TB WD).
> Read: 1.2Gbyte/sec
> Write: 1.2Gbyte/sec
> 
> === NETWORK
> When I run iperf between the two 10GbE interfaces, I get 1.1-1.2Gbyte/sec.
> MTU=9000 on both hosts.
> 
> == COPY OVER NETWORK
> When I copy using cp/NFS, tar/nc, etc.. I only see an average of about 
> 250MiB/s, I also have two desktop boards (8GB ram/ea) from which I get 
> 500-550MiB/s from (the raid is slower on the desktop boards, it gets what 
> the RAID can read it), how come these server boards cannot push > 1Gbyte/sec
> sustained?
> 
> I know on this board:
> CPU1 => SLOT 1,2,3
> CPU2 => SLOT 4,5,6,7
> 
> The RAID card is plugged into 2 (CPU1)
> The 10GbE card is plugged into 6 (CPU2)
> 
> Should both cards be plugged into the same set of slots controlled by the 
> same CPU?
> 
> Has anyone experienced anything like this before, e.g., > 1Gbyte/sec read 
> & write for network and 3ware RAID but when using them in combination, it 
> is slow.
> 
> OS = CentOS 5.5 x86_64
> Filesystem = XFS
> NIC = 10GbE AT2 Server Adapter
> 
> No single component is < 1Gbyte/sec but when data is transferred from 
> hostA to hostB, then it degrades to 250MiB/s.
> 
> Justin.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jean Gobin, CCENT, CCNA, CCNA Security

-----------------------------------------------------------------------
http://newsfromjean.blogspot.com/

