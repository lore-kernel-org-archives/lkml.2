Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1IGRv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:51:29 -0400
Received: from gw1.transmode.se ([195.58.98.146]:44862 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab1IGRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:51:27 -0400
In-Reply-To: <035901cc6d7b$77065350$6512f9f0$@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com>
	<20110902165047.6aaec238.akpm@linux-foundation.org>	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>
	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>	<20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au> <20110906123851.dc4de9f5.akpm@linux-foundation.org> <035901cc6d7b$77065350$6512f9f0$@systemfabricworks.com>
Subject: RE: [PATCH v6 05/10] crc32-misc-cleanup.diff
X-KeepSent: 1BC44A31:C055969E-C1257904:0061969E;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, fzago@systemfabricworks.com,
        "'George Spelvin'" <linux@horizon.com>, linux-kernel@vger.kernel.org,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF1BC44A31.C055969E-ONC1257904.0061969E-C1257904.0062171D@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 7 Sep 2011 19:51:24 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/07/2011 19:51:25
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/09/07 18:30:31:
>
> >
> > The list of needed changes based on recent comments I am aware of are:
> >  - put back in a couple of header files per Andrew
> >  - fix the summary phrases to conform to coding standards per Andrew
> >  - add signed off by for Joakim to patch 04/10 per Joakim
> >  - fix bug in patch 06/10 noted in my email by passing bits as a parameter
> to
> > crc32_body
> Adding three additional changes:
>  - update macro per Joakim
>  - shorter generator code per George
>  - remove unneeded local_irq_disable per Andrew
> Any more?

There was more in my comments. Don't you scroll through the whole reply
when you read it? Especially this one:
  "BTW, is the 64 CRC bits on 32 bits BE arch bug fixed?"

>
> Can we finish crc32 before we start boiling the ocean with crc32c, crc16
> etc.? I am happy to pitch in on those but I would like to see something
> actually get done. I actually need this one.

Yes, lets get this cleared first. The other stuff depends on this.

