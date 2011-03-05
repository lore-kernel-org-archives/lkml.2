Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1CEW7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 17:59:39 -0500
Received: from plecavalier.com ([64.40.149.83]:39314 "EHLO plecavalier.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1CEW7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 17:59:39 -0500
Content-Type: text/plain; charset=UTF-8
Subject: [RESOLVED] Re: Second drive on VT6421
From: Philippe LeCavalier <support@plecavalier.com>
To: =?utf-8?q?Alejandro_Riveira_Fern=C3=A1ndez?= <ariveira@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <1299355624-sup-9766@plc.intranet.plecavalier.com>
References: <1299350988-sup-2113@plc.intranet.plecavalier.com> <20110305210537.7675b600@varda> <1299355624-sup-9766@plc.intranet.plecavalier.com>
Date: Sat, 05 Mar 2011 17:59:34 -0500
Message-Id: <1299365533-sup-1295@plc.intranet.plecavalier.com>
User-Agent: Sup/0.12.1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I tried setting both drives to 1.5Gbps on a whim and low and behold it
worked. btw. setting a single drive to 1.5 didn't help. I had to set
both.

I had considered this from the beginning but thought that since each
drive was detected on their own at 3Gbps there was no good reason they
couldn't both.
There must be something about that chip...Perhaps the way the firmware
allocates the bandwidth. ie 2 channels with a total of 3Gbps then a
second drive cannot coexists if the first requests all 3Gbps?!

Excerpts from Philippe LeCavalier's message of Sat Mar 05 15:07:33 -0500 2011:
> thx.
> 
> If I can provide more nfo pls ask.
> 
> Excerpts from Alejandro Riveira Fernández's message of Sat Mar 05 15:05:37 -0500 2011:
> > El Sat, 05 Mar 2011 14:00:44 -0500
> > Philippe LeCavalier <support@plecavalier.com> escribió:
> > 
> >  Adding linux-ide to CC
> > 
> > > I know it's been discussed but since it's been a while, has anyone
> > > managed to get a second drive detected with this card?
> > > 
> > > I'm on Deb Squeeze with 2.6.32-5
> > > 
> > > sata_via is loading fine and I can see the drives if they're connected
> > > individually but not if I connect both. If I do connect both I only see
> > > one of them -which is always from the same port-.
> > > 
> > > To be clear, I'm not referring to the eSATA port. I'm not up to that
> > > yet.
-- 
Thanks,
Phil
