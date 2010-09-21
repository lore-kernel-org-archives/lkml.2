Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0IUOMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:12:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:57431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0IUOMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:12:50 -0400
Date: Tue, 21 Sep 2010 16:12:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hid: 3m: Adjust to sequential MT HID protocol
In-Reply-To: <1213242F-BA51-4D3C-93F9-5CF29DEC513B@enac.fr>
Message-ID: <alpine.LNX.2.00.1009211612400.26813@pobox.suse.cz>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1213242F-BA51-4D3C-93F9-5CF29DEC513B@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Stéphane Chatty wrote:

> > The multitouch extensions to the HID protocol allows for contact
> > data to be sent over several reports, which is also the case for
> > the 3M M2256PW touchscreen. This patch modifies the logic to only
> > synchronize the input layer when all contacts have been received.
> > Consequentially, the full 60-finger capacity of the device is enabled.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hid/hid-3m-pct.c |   22 ++++++++++++++++++----
> >  1 files changed, 18 insertions(+), 4 deletions(-)
> 
> You can add
> 
> Acked-by: Stephane Chatty <chatty@enac.fr>

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
