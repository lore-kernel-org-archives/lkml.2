Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2IYIz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:55:27 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:53056 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYIzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:55:23 -0400
Message-ID: <50617178.8090700@asyr.hopto.org>
Date: Tue, 25 Sep 2012 11:55:20 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org> <20120924231216.GA20015@electric-eye.fr.zoreil.com>
In-Reply-To: <20120924231216.GA20015@electric-eye.fr.zoreil.com>
Content-Type: multipart/mixed;
 boundary="------------050605080309080407010206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050605080309080407010206
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

on 09/25/2012 02:12 AM Francois Romieu wrote the following:
> Thanasis <thanasis@asyr.hopto.org> :
>> Attached the whole log so far.
>> (the process looks stuck anyway for more than 30 min at the same point)
> 
> You don't need to wait that long.
> 
> I have updated git://violet.fr.zoreil.com/romieu/r8169 with a
> '3.2.r8169.backport' branch.
> 
> You can remove your existing r8169 git tree, clone this one and start
> the same tests against a 3.2 kernel.
> 

I don't know what's wrong, but I am getting those errors.
Are you sure about the git tree?



--------------050605080309080407010206
Content-Type: application/x-gzip;
 name="lets-go-3.2.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lets-go-3.2.log.gz"

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
SPA/YvnnKqMqAQA=
--------------050605080309080407010206--
