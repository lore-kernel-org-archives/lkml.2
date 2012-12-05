Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2LEDYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 22:24:23 -0500
Received: from plane.gmane.org ([80.91.229.3]:34507 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab2LEDYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 22:24:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Re: Why a host not ping-able?
Date: Wed, 5 Dec 2012 03:24:00 +0000 (UTC)
Message-ID: <slrnkbtfgm.us1.narkewoody@zuhnb712.local.com>
References: <slrnkbr59r.us1.narkewoody@zuhnb712.local.com>
 <1354620894.27682.5@driftwood>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.37.26.98
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-04, Rob Landley <rob@landley.net> wrote:
> On 12/04/2012 12:17:25 AM, Woody Wu wrote:
>> Hi, list
>> 
>> I am not sure this has something with kernel.
>
> It doesn't.
>
>> But the system I just
>> generated cannot be reached from ping.  It can ping outside, but if I
>> ping it from outside, I just get "Destination Host Unreachable".
>
> Some distributions' default firewall rules respond to icmp packets with  
> a host unreachable packet. This is a system/network administration  
> thing (iptables) and nothing to do with kernel development.
>
>> I think there is not firewall in between,
>
> There's a firewall  built into linux, read the man page for the  
> "iptables" command. The "iptables-save" command dumps your entire  
> current ruleset to stdout so you can see what's in there. (You might  
> have to run it as root, I forget.)
>
> https://help.ubuntu.com/community/IptablesHowTo
>

This 'distribution' I am running is a tailor linux 3.4.19 on an embedded
system (Samsung S3C2410).  Because this is a very small system, I
believe I did not add any ip-table options in the kernel. And, I did not
install any user space firware packet for it.  So maybe this is really a
firewall play in between.

Now I run tcpdump on the target system with 'tcpdump -i eth0'. Then when
I ping it from another Linux box, I see nothing from the tcpdump output.
Does this confirm there is a firewall blocked the ping packets?

Thanks in advance.


-- 
woody
I can't go back to yesterday - because I was a different person then.

