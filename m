Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KWJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:25:27 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:47206 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752248Ab0KWJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:25:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=Ei6gNbEiqMDf4g2n/0+wBsllaOLmcvX2Dq50E/UZHfyk776ZD6OD7Yd5DRpnhkg19ICbNuijCTVszmL7pv99wCqqnBeaBZhVHw964ooiMxBP6c4JwQ52llW+RNWinsYpCpcYETi16greXgAgO4FijkTxQRRsDFhbqQxczPu7Zxs=;
Message-ID: <589506.10541.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: FPlLS44VM1mElQl04hlehk7JgHdWNMZogg7kh4u63Mum1dJ
 5v8FCHFJdNiLnvM3h6n_7gPksTy0uWqqUDJmbbwFgnL6cP8.O80qfp7AK5aJ
 xxmkKCC8AYZH2WaoEDdv0kuthCa0y3OvHLB9T2bt47ZTQqGlQHM1jVn1bd7N
 KdyqkaU0jnZRkmE6fkn.wlHEAsp7_lHFVUnFB.evQRHl0YC8YHplhvcKWSGr
 EZtQzCDao1yk2ba381cHL38MWPzCRJo9btPBAAMpXEXglYJjFcD0mq2IGa9a
 PGutgRoEtVyf5PSJIDWc.p6VN9KPncAD4qN_OfML4BLItVThVwZ1gx6cvzj7
 sejLbyz0J6YDxMxC_4t0jF9MioXyLivIW.LL0
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 23 Nov 2010 01:25:23 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20101123050048.GL20296@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:

> As long as you are not changing the command stream that the
> devices see, I
> think this is a reasonable risk to take.

No, not at all.

> What are the consequences if the device returns what appear
> to be a Caching
> Mode Page, but it is actually filled with garbage or
> otherwise inaccurate
> data?

Data corruption would be no different than when determining whether the media is write protected or determining other parameters. A similar question would be "What would the consequences be if the device misreported the media write-protect bit?" I suppose such a device would be quite broken and inoperative.

   Luben

