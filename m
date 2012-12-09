Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2LIGVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 01:21:25 -0500
Received: from plane.gmane.org ([80.91.229.3]:50354 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab2LIGVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 01:21:24 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Re: 8250 UART doesn't work
Date: Sun, 9 Dec 2012 06:21:09 +0000 (UTC)
Message-ID: <slrnkc8bco.3do.narkewoody@zuhnb712.local.com>
References: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
 <50C0E737.2000201@zytor.com> <slrnkc2o7b.2ck.narkewoody@zuhnb712.local.com>
 <20121207100438.136dd968@pyramind.ukuu.org.uk>
 <slrnkc6si6.3do.narkewoody@zuhnb712.local.com>
 <20121208225233.169ba5b9@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 119.142.38.140
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Which kind of configuration is right for ARM?  I think the
>> 8250_exar_st16c554.c is for ISA bus board and hence is not suit to me,
>> but I am not sure my understanding is right. Please give me some
>> backgroud information on this field.
>
> You are the one who should have the information for your board. If not
> ask your board vendor how it is all mapped.
>
> Alan

I have no more information for the board. For now, I just want to gain
some knowledge about the UPIO_MEM and UPIO_PORT - what is for what.
Hope experts on the list can be so kind to help me.  Thanks.


-- 
woody
I can't go back to yesterday - because I was a different person then.

