Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1KANNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:13:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35547 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1KANNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:13:14 -0400
X-Sasl-enc: jsPjw1np76TehoH9u1RjUWbJKa3dlU2qe4TavwJyg4Dx 1320153193
Date: Tue, 1 Nov 2011 11:13:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "hpanvin@gmail.com" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111101131309.GA30604@khazad-dum.debian.net>
References: <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <4EAF1731.2070908@zytor.com>
 <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com>
 <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com>
 <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
 <4EAF66C7.6080909@zytor.com>
 <CA+55aFwycceEN7itYama6H4gwAK-OQdqZ5uo9Pdg9ATqPTPtWQ@mail.gmail.com>
 <3f01b4a5-8dfa-4eb4-bfa3-490d5ebf0281@email.android.com>
 <1320124759.7701.2.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320124759.7701.2.camel@dabdike>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Nov 2011, James Bottomley wrote:
> On Mon, 2011-10-31 at 21:25 -0700, hpanvin@gmail.com wrote:
> > Body searches are still slow, at least with dovecot on the server.  No
> > idea about gmail as the server.
> 
> Actually, my experience is different.  I do use body searches a lot (not
> TSA approved ones, obviously) and I found they're much faster after
> switching to dovecot (from wu-imapd).  However, they also burn massive
> amounts of CPU time on my server, so it probably helps that I only have
> a couple of mail users.

Well, Cyrus IMAP provides fast server-side body searches using indexes, but
you'd have to configure it properly to use that feature.  It is lightweight
on the server side after the initial indexing (yes, it can do incremental
and staggered indexing).  Maybe Dovecot also needs some configuration to
index mailboxes for fast searching?

wu-imapd is not something one should bring up on polite conversation.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
