Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2BNSRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:17:33 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36862 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2BNSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:17:30 -0500
Message-ID: <4F3AA537.4050700@hp.com>
Date: Tue, 14 Feb 2012 10:17:27 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Divy Le Ray <divy@chelsio.com>, David Woodhouse <dwmw2@infradead.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        nhorman@tuxdriver.com
Subject: Re: [patch net-next] cxgb3: update firmware version
References: <20120213202846.631.30806.stgit@speedy5.asicdesigners.com> <1329165817.2092.62.camel@shinybook.infradead.org> <4F398303.1030606@chelsio.com> <1329184754.3048.33.camel@deadeye> <4F39E7C9.20901@chelsio.com> <1329196116.3048.66.camel@deadeye> <4F39F75D.6030107@chelsio.com>
In-Reply-To: <4F39F75D.6030107@chelsio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What does an end-user/customer see and do?  When they are told that 
version the firmware, specified down to the fix level, fixes a problem 
they are having, how will they know that firmware blob filename 
drvfw-X.bin on a download/archive site has that fix?  Yes, the support 
folks can say "It is the drcfw-X.bin file which is 12345 bytes in size 
with the MD5sum of <blah> but the principle of the telephone game 
dictates the size and/or MD5sum information will drop as "the word" 
passes from one person to another. And one cannot run 
ethtool_ops::get_drvinfo against a website.  Two versions may indeed be 
"compatible" in terms of interfaces, but they won't be identical in 
terms of desirability.  As such, for them to be contained in files with 
identical names just seems like asking for confusion.

Firmware is something of a tiny kernel no?  Would we have everyone name 
vmlinux files with just a major number?

rick jones
