Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0H3Ng4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:36:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0H3Ngy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:36:54 -0400
Date: Mon, 30 Aug 2010 15:36:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
In-Reply-To: <75AEF6DA-F09E-4B90-8E89-6F5B668724C9@enac.fr>
Message-ID: <alpine.LNX.2.00.1008301535300.1019@pobox.suse.cz>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>  <1283005748-3293-3-git-send-email-rydberg@euromail.se>  <2A410207-8AAA-4D5A-846A-B69F007E6800@enac.fr> <4C79346F.4050409@euromail.se> <75AEF6DA-F09E-4B90-8E89-6F5B668724C9@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Aug 2010, Stéphane Chatty wrote:

> > I think we use the term tracking id differently here. The HID_DG_CONTACTID
> > is
> > actually the slot id, and the tracking id is a sequential number, increased
> > whenever the touch is new. I believe the patchset works correctly as long as
> > there is less than 32768 new touches before releasing the oldest one. :-)
> 
> Oh, right. I definitely need to catch up with Protocol B.

Henrik,

thanks a lot for the patches.

Stephane, could you please send me your Acked-by for those changes? I'd 
like to have this before applying them.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
