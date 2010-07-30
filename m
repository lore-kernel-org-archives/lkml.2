Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0G3WBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:01:54 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:43501 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755290Ab0G3WBv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:01:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 967462.197.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IV+Ebnfkyd85O4DW5R0r/p/JGCnMJlFI9/1/Lq7EJQJ/EopxhoVPYyqr56RG2hVOLcTkN7XCrW7huC2AybCbLhj4KH9lRwiWdxEyZHjWE7d9TViMC3TUtKsEh3/MwDtZWZ0tF7Z3joI4zolre+KwfhZim0rHFdpQxVJK3bn1nNQ=;
Message-ID: <842657.61658.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: YmR4rxMVM1mn3aTfo3ANx.IWEuvUxwxlUawVOpEl.1HtRcZ
 8VFaC4catcXwNzrKakN6.xnaVbUR.u8500Q1_6NviPmOWp_jDNcl53Y_BbeE
 ZvGPYSEMrdJVXZReUnzGrp0lwB0xXiJ2NCl0HS8hdNQz4VPfVWHcdknmvC_A
 Nbiba42FvOdy0rikWNTuAx2PCtfdfESRzAuMm2S2aauOXL1otijCwpJifWrr
 47veqbMHsJf0uyLYCyfeDK5HpctnbZ86qnSTrLYU23KNO676gl9UUdx.3waz
 7KiKv_.WnORrqKVTut8hx9cg5h_sq28PcdXG6sm0-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.279950
Date: Fri, 30 Jul 2010 15:01:50 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets
To: Greg KH <greg@kroah.com>
Cc: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <20100730212131.GA8787@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > That's too extreme; the original handful of
> > NetChip IDs were (and are!!) correctly assigned,
> > and there's no reason to change them.  In fact,
> > there's a lot of reason to continue using them
> > while config files and drivers expect to see
> > those specific IDs (as is reasonable).  That's
> > to avoid breaking working configs...
> 
> True, I was thinking that for the class-type devices, we
> could use the
> linux foundation vid, as changing them shouldn't
> matter right?

There are INF files using NetChip IDs, so
changing them would break stuff.

Newer interfaces using new VIDS/PIDS?  Fine.
> 
> Or does Windows really care about the vid/pid for
> a class device somehow?

My understanding is that it does, since it really
doesn't have a good concept of "class" being the
generic thing.  INF files embed VIDS/PIDS even
for drivers implementing class specs.  MSFT was
being stupid again...

- Dave



