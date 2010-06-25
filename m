Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0FYGQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:16:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0FYGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:16:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: 2.6.35-rc1 system oom, many processes killed but memory not free
Cc: kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTiniN949ew8asVksRw6EEBlcs2yy2pZ7Eir33oiy@mail.gmail.com>
References: <20100625133542.8047.A69D9226@jp.fujitsu.com> <AANLkTiniN949ew8asVksRw6EEBlcs2yy2pZ7Eir33oiy@mail.gmail.com>
Message-Id: <20100625151248.804A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 15:16:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes I made a mistake setting up ramdisk too big, but not sure why it
> allowed me to set it up like that.

Sorry, I don't know the reason. 

> I think after ramdisk used all the memory, even after unmounting then
> other processes still cannot use it.
> oom killer gets very aggressive but cannot fix problem.
> 
> I have updated to rc3 and will test again on weekend. I will turn on
> mem leak checker, is there anything else i should configure?

Probably nothing.

Thanks.


