Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0KFGwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 02:52:05 -0400
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:26699 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753443Ab0KFGwD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 02:52:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TLhegPlivmyX7C5iSONcRi5kWSzycUoY/BrFPtcu2rm7a5KgEMjqFnrvedida8ZqAA8SKJC7EoW1JFr3dSNR6D9rGUJ08CNN1WRBXvmZVtgcG0igOxPMvvRmqM+ATc6PUncon+TirtH5NmKPTusJAVQkHUxvCEl7Nn7+plcR3dk=;
Message-ID: <87456.32791.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: kqicqmQVM1lhcGsQTTy.m7rdDvkbOF04aG.dERMGHl3Pk9r
 2jtmvvgS1ysr1GS8h9a86HdVWr2zAkqw4._c881Chd8MkB9FaI6vswwMPkET
 E9BaAvvU3H5MX8jaVso08bGA2y1ke37A4e4Np6phTEmn1ZaxbRkxOsT6Jcyw
 09baw3MFMDf43pIoyc_Sg2Lk6vj45BB8vzPqrXUBwIg.xQMHyDh.GjVmX6hy
 6qadikisqB8A8ZSWj8s3QRb40rMGMiX.l7x3nFTt4OXKP2NLIkRxxDb_tErI
 AbUX04NiK5Es5JPvd1f04YidYVpQsHDlh06mTgdJheU0A2YvNrWtcr2Q8n.c
 6UylRJn4-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Fri, 5 Nov 2010 23:52:00 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <20101106051447.GA2327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 11/5/10, Greg KH <greg@kroah.com> wrote:
> > This patch changes 86% of the driver. More is to come,
> but this is
> > a self-contained patch so it can be applied.
> 
> No it can not at all, sorry.

Greg, would you accept a brand new driver, say uastoo.c (just like
8139too.c came about, remember?), or would you say "This is 14% the same
as uas.c, and thus cannot go in"?

Is 14% difference too much or too little?  Surely, the sum of
small tiny individual patches, *would* replace 86% of the driver. BTW,
there are more things to fix even on top of that.

(I wonder how much similar 8139too.c was to rtl8139.c... when 8139too.c
got in back about 10 years ago? I bet it was more than 14%. Hey, I'm building precedent here.)

Or would you say "only individual patches even if it changes 100% of the
code".

> Remember, patches do one single thing at a time.

I wholeheartedly agree. One thing at a time. Self-contained, well defined. 

I really did want to do that with uas.c but it was really hard. I was
like "where to begin?"  There was no one single change to say "here it
is" without changing something else.

> This patch is equivalant to deleting the file and replacing it with a
> totally different driver, which is unacceptable.

I did want to submit them one at a time. I really did. But one change
necessitated another in order to keep things consistent, and it ended
up like this, one single commit in my git tree.

I really do have one single commit as this "patch".  I really did want
to submit it as individual one at a time. But there was no well defined "one at a time".

> Please break all of these changes up into individual
> patches and resubmit them.  That's the only way we can take
> them.

That, or a new driver perhaps?
The net effect of individual patches would be the same, leaving only
14% of the code the same and maybe less with the more work pending.
Perhaps a new driver acknowledging it is based on this one FWIW?

> I also suggest you go re-read Documentation/development_process/ as well.

Did Willy reply to your query about the previous patches? I didn't see
his reply.

