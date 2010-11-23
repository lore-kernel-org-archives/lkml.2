Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882Ab0KWInN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:43:13 -0500
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:42725 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750736Ab0KWInL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:43:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fnEFKAzoZavnzWteZOQdlqdYfFoRUsJHPxeR729CcZurS5vdizTmqD1A/AMwlRtZ2q2pN6IVH7F5FqR6bwvVmpH+w3rTAET/K1F7R9tDHLfumQcsGc/Rm4DPzZOYOEbiiN/GnPAK7aSCkzlete//+pQh0tbepdgSgZsAXKG2VkU=;
Message-ID: <987735.18126.qm@web31812.mail.mud.yahoo.com>
X-YMail-OSG: zx.M2HIVM1nED880xlMYYI2knn8jRG6LQ83rKQmWoi.VEEu
 bjXk0pOAluePPHtTS9ZWUXeoXBp4cUHcYQpamJeMI7QiF6H1rGGJTYXbprX3
 sT.p7emvVobMXqcTgw.IeIayH1vTSMXWrrbNmBTsXaat4hrDYNBykgfoc8tW
 W_VQPGKDngpvPTMdU3kccX78SYren5TRA1I3niKKa0sv2Y4Nrsk1qu4QE_Ra
 CyKvc_TZWYusPSXu5p84S5HWJYhxSkUyo1io_nKxkKud0QPjrkRzpCaNtbhj
 bY2dxEpqjlcTpJeNWSDm6.PAxgOWjNbg8nB0eeUgsYRWlgFCzTOgDhUJRRWu
 77MjV2JWagw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 23 Nov 2010 00:43:09 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: Douglas Gilbert <dgilbert@interlog.com>,
        Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:

> That said, Luben's patch is kinda slick.

Thank you.

> sd-modalready asks for a lot of
> mode page data; it does this so that it's request matches
> the observed
> behavior of a "popular" Redmond, WA-based OS.  Luben's
> patch just searches
> through that data to see if it can find what it is looking
> for, rather than
> rqeuesting a specific mode page later (which may not be
> supported).

Yes, devices wouldn't sense a change in requests. The patch preserves this quality of device discovery.

   Luben

