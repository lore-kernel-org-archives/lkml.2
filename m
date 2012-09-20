Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2ITXi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:38:59 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:56778 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2ITXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:38:57 -0400
Date: Fri, 21 Sep 2012 01:20:30 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thanasis <thanasis@asyr.hopto.org>, LKML <linux-kernel@vger.kernel.org>,
        nic_swsd@realtek.com
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120920232030.GA9224@electric-eye.fr.zoreil.com>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> :
[...]
> Thanks.  I don't see anything wrong from the PCI core point of view.
> But searching for "r8169 transmit queue timed out" found lots of
> similar reports.

It's a rather common symptom when things go wrong :o/

> +cc 8169 driver folks

(thanks)

Thanasis, can you narrow down a bit the failing revision ?

I'm ok with building a set of ad-hoc backported r8169 drivers to find
the culprit - if the problem lays there - but I won't mind avoiding
a few tens of unneeded changesets.

-- 
Ueimor
