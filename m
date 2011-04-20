Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1DTJMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:12:03 -0400
Received: from liner.boxed.no ([89.250.115.71]:55416 "EHLO liner.boxed.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1DTJMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:12:01 -0400
Message-ID: <4DAEA35F.3030908@boxed.no>
Date: Wed, 20 Apr 2011 11:11:59 +0200
From: Alexander Hoogerhuis <alexh@boxed.no>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: A patch you wrote some time ago (aka: "[patch 41/54] ICMP: Fix
 icmp_errors_use_inbound_ifaddr sysctl")
References: <20110419165411.GO9569@sequoia.sous-sol.org> <4DAE9824.10802@trash.net>
In-Reply-To: <4DAE9824.10802@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, in a quick followup on myself, this is ambiguous, as it does not 
state that it will select the primary IP. I've

The second part is that RFC 5798 (VRRP v3) lists in section 8.1.1:

>    The IPv4 source address of an ICMP redirect should be the address
>    that the end-host used when making its next-hop routing decision.

I.e. the settings in linux, with or without the sysctl flag set, would 
run against this.

mvh,
A
-- 
Alexander Hoogerhuis | http://no.linkedin.com/in/alexh
Boxed Solutions AS   | +47 908 21 485 - alexh@boxed.no
"Given enough eyeballs, all bugs are shallow." -Eric S. Raymond
