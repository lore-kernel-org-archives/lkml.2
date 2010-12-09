Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0LIWn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:43:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14290 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0LIWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:43:26 -0500
Date: Thu, 9 Dec 2010 23:36:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: Start dropping PCMCIA from compat-wireless for 2.6.38+
In-Reply-To: <AANLkTikc_u4NhxdGzwQMjbEe12qYmhq481amazTK-JRc@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012092335380.25880@swampdragon.chaosbits.net>
References: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com> <alpine.LNX.2.00.1012092329480.25880@swampdragon.chaosbits.net> <AANLkTikc_u4NhxdGzwQMjbEe12qYmhq481amazTK-JRc@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Luis R. Rodriguez wrote:

> On Thu, Dec 9, 2010 at 2:31 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Thu, 9 Dec 2010, Luis R. Rodriguez wrote:
> >
> >> I'm going to start dropping PCMCIA stuff from compat-wireless as I
> >> don't think we have any users of it nor interest to keep backporting
> >> it. This entails dropping drivers like orinoco, b43 PCMCIA support,
> >> libertas, as well as bluetooth bluecard_cs, bluecard_cs, dtl1_cs,
> >> bt3c_cs and of course CONFIG_SSB_PCMCIAHOST. If you are a user please
> >> yell now.
> >>
> > Yelling.
> > While I'm not personally a user, my mother is. She still has an old IBM
> > Thinkpad 600 laptop with a PCMCIA card in it that uses the orinoco driver.
> 
> And you have your mother using compat-wireless?
> 
Yes, as a matter of fact I do.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

