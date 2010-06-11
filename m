Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513Ab0FKUqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:46:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0FKUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:46:45 -0400
Date: Fri, 11 Jun 2010 13:46:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: dvomlehn@cisco.com, to@dvomlehn-lnx2.corp.sa.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/4][RFC] Introduction to sk_buff state checking
Message-Id: <20100611134617.b2c93c1b.randy.dunlap@oracle.com>
In-Reply-To: <20100611.133811.52184181.davem@davemloft.net>
References: <20100611203350.GA28383@dvomlehn-lnx2.corp.sa.net>
	<20100611.133811.52184181.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4C12A0AC.0088:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 13:38:11 -0700 (PDT) David Miller wrote:

> 
> This is the second time you've submitted this patch set,
> it is also the second time that:
> 
> 1) Your email client has emitted these strange
>    "linux-kernel@vger.kernel.org"@cisco.com
>    addresses.
> 
>    I saw that you were specifically notified about this
>    problem during the previous submission.
> 
>    What did you do to try and correct it?
> 
> 2) You are not CC:'ing the networking developer mailing
>    list "netdev@vger.kernel.org"  Many networking developers
>    do not read linux-kernel, so by not CC:'ing that list
>    you are not reaching the folks most capable of reviewing
>    your patches.
> 
> Please fix this up.
> --

Ack.  Also this one:

   ----- The following addresses had permanent fatal errors -----
<to@dvomlehn-lnx2.corp.sa.net>
    (reason: 550 Host unknown)

   ----- Transcript of session follows -----
550 5.1.2 <to@dvomlehn-lnx2.corp.sa.net>... Host unknown (Name server: dvomlehn-lnx2.corp.sa.net: host not found)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
