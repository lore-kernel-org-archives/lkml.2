Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1BHMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:06:19 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:53929 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955Ab1BHMGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:06:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=U3FczqoMEcpJvy2WyNOBJaZ5mNHLT2Zl1ofodfHy0nTSnelELDoExABEHSPmVByP;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D5131B6.4050205@earthlink.net>
Date: Tue, 08 Feb 2011 07:06:14 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Steve Clark <sclark@netwolves.com>
Subject: ipsec with ipv4 and ipv6 not working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec799fc74f27dc2289ee26d8cd1fa9f214b5350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

How do I find out what is happening to my packets thru my ipsec tunnel.
They just seem to disappear on the remote side.

I have successfully got the pings thru
when everything has an ipv6 address, but am not successful when trying
to connect two ipv4 lans across an ipv6 ipsec tunnel. All fw chains both 4 and 6
are set to ACCEPT. NAT is turned off.

      eth0               eth1                                         eth1 
       eth0
10.1.254.254/17  2001:xxxx:1628::254 <----ipv6 internet -----> 
2001:xxxx:e334::254  10.0.254.254/17

12:00:02.296972 IP6 2001:xxxx:1628::254 > 2001:xxxx:e334::254: 
ESP(spi=0x07454bc3,seq=0x28b), length 132
12:00:03.308751 IP6 2001:xxxx:1628::254 > 2001:xxxx:e334::254: 
ESP(spi=0x07454bc3,seq=0x28c), length 132
12:00:04.296857 IP6 2001:xxxx:1628::254 > 2001:xxxx:e334::254: 
ESP(spi=0x07454bc3,seq=0x28d), length 132
12:00:05.293748 IP6 2001:xxxx:1628::254 > 2001:xxxx:e334::254: 
ESP(spi=0x07454bc3,seq=0x28e), length 132
12:00:06.296623 IP6 2001:xxxx:1628::254 > 2001:xxxx:e334::254: 
ESP(spi=0x07454bc3,seq=0x28f), length 132

I have posted to the ipsec-devel list and haven't gotten any responses. Also I 
have spent 2 days googling with
no results about the above setup. Is it even possible to tunnel ipv4 packet thru 
an ipv6 ipsec tunnel?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



