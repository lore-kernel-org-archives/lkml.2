Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1HZDNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 23:13:22 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:40330 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab1HZDNO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 23:13:14 -0400
References: <4E5494D4.1050605@profihost.ag> <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com> <4E54BDCF.9020504@profihost.ag> <20110824093336.GB5214@localhost> <4E560F2A.1030801@profihost.ag> <20110826021648.GA19529@localhost> <4E570AEB.1040703@profihost.ag> <20110826030313.GA24058@localhost>
In-Reply-To: <20110826030313.GA24058@localhost>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <D299D0AE-2F3C-42E2-9723-A3D7C0108C40@profihost.ag>
Cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
X-Mailer: iPhone Mail (8H7)
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
Date: Fri, 26 Aug 2011 05:13:07 +0200
To: Wu Fengguang <fengguang.wu@intel.com>
X-User-Auth: Auth by s.priebe@profihost.ag through 79.238.41.38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> There is at least a numastat proc file.
> 
> Thanks. This shows that node0 is accessed 10x more than node1.

What can i do to prevent this or isn't this normal when a machine mostly idles so processes are mostly processed by cpu0.

> 
>> complete ps output:
>> http://pastebin.com/raw.php?i=b948svzN
> 
> In that log, scp happens to be in R state and also no other tasks in D
> state. Would you retry in the hope of catching some stucked state?
Sadly not as the sysrq trigger has rebootet the machine and it will now run fine for 1 or 2 days.

> 
>>>         echo t>  /proc/sysrq-trigger
>> sadly i wa sonly able to grab the output in this crazy format:
>> http://pastebin.com/raw.php?i=MBXvvyH1
> 
> It's pretty readable dmesg, except that the data is incomplete and
> there are nothing valuable in the uploaded portion..
That was everything i could grab through netconsole. Is there a better way?

Stefan
> 
