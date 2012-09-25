Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2IYKMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:12:55 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37857 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IYKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:12:54 -0400
Date: Tue, 25 Sep 2012 11:54:03 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120925095403.GA29497@electric-eye.fr.zoreil.com>
References: <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org> <20120924231216.GA20015@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50617178.8090700@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
[...]
> I don't know what's wrong, but I am getting those errors.
> Are you sure about the git tree?

Yes. Replace 'git rev-list --all' with 'git rev-list --branches'.

It should show something like:
$ git rev-list --branches
a65a9b5d9c4569228909e36bb6e20d33fe208950
35417352eeec6fcfcb92796d3473ea0ed2624f5e
[...]
ec0c1f64e5751d0634c4afad9895c09d9a23da5f
b8a75250cee0d3c36b62038640b66d185c79fe34

Then, when test starts:
[...]
HEAD is now at b8a7525 3.2 r8169 driver and out-of-tree Makefile.

Sorry for the confusion.

-- 
Ueimor
