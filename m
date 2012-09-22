Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2IVGUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 02:20:39 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:55152 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2IVGUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 02:20:38 -0400
Message-ID: <505D58B3.4090008@asyr.hopto.org>
Date: Sat, 22 Sep 2012 09:20:35 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CBDF9.9020503@asyr.hopto.org> <20120921202957.GA32502@electric-eye.fr.zoreil.com> <505CD982.2000409@asyr.hopto.org> <20120921225343.GA2938@electric-eye.fr.zoreil.com>
In-Reply-To: <20120921225343.GA2938@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 09/22/2012 01:53 AM Francois Romieu wrote the following:

> You did experience a failure with a 3.5.4 kernel. Can you try a 3.2.x if
> your vendor provides one ?
> 

The vendor does not provide a 3.x kernel. But I will compile one.
Do you want me to run the r8169 make tests, if the r8169 of the 3.2.x works?

