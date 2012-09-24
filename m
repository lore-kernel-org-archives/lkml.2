Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab2IXXbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:31:07 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:36855 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2IXXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:31:06 -0400
Date: Tue, 25 Sep 2012 01:12:16 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120924231216.GA20015@electric-eye.fr.zoreil.com>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505CC65D.9010605@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
> Attached the whole log so far.
> (the process looks stuck anyway for more than 30 min at the same point)

You don't need to wait that long.

I have updated git://violet.fr.zoreil.com/romieu/r8169 with a
'3.2.r8169.backport' branch.

You can remove your existing r8169 git tree, clone this one and start
the same tests against a 3.2 kernel.

-- 
Ueimor
