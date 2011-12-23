Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1LWPXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:23:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58336 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LWPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:23:07 -0500
Date: Fri, 23 Dec 2011 15:22:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Brian Swetland <swetland@google.com>, david@lang.hm,
        NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111223152231.4a304fdd@pyx>
In-Reply-To: <20111222060917.GA16302@suse.de>
References: <4EF264C3.6000104@am.sony.com>
	<20111221231956.GB23859@suse.de>
	<4EF27B85.9080801@am.sony.com>
	<20111222122026.3a0fae36@notabene.brown>
	<alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
	<CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
	<alpine.DEB.2.02.1112212107550.28597@asgard.lang.hm>
	<CANqkERCH15aGi5TJwUk6Yg3fnrPA0aiTJa=Nz9sUeZLbWs20HA@mail.gmail.com>
	<20111222060917.GA16302@suse.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have no problem leaving the logger driver in staging, but it seems
> that Tim is taking on the task to do the harder thing here, which
> probably would entail work on both sides, which as a openhandset
> alliance company member, he might have a change that someone like me
> might not :)

I'd like to see it in staging. There is a general discussion going on
about how such logging services should look (and indeed it goes back
before Android bits), and it looks like a good way to proceed is going to
be to "play" with the Android one - perhaps adding the fs model to it.

So we need something and the Android interface at the very least is a
prototype that has production proof of working.

Alan
