Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1CJSCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:02:33 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:53201 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab1CJSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:02:32 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Mar 2011 19:04:55 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
Message-ID: <20110310180455.GA24888@polaris.bitmath.org>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1103011702240.32580@pobox.suse.cz>
 <AANLkTikd67q_j_ySam7RZvau8WoESLEmdXkfCWerVrLp@mail.gmail.com>
 <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
 <20110310161635.GA23223@polaris.bitmath.org>
 <alpine.LNX.2.00.1103101859070.19969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103101859070.19969@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxkBZ-0005RB-Bx.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PxkBZ-0005RB-Bx c654d816d097e48cd048f77fee6d68fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I was wondering if this patch will appear in the final 2.6.38? It
> > seems the regression it fixes is pretty severe for ntrig devices, and
> > once out there, the callback argument change will create problems for
> > add-on modules such as dkms modules.
> 
> Hi Henrik,
> 
> I am not sure Linus will be taking it for .38 still, as he is now offline 
> and will be releasing final .38 after he appears, so it's unlikely that 
> he'll take pull requests unless it's something super-severe.
> 
> I'll put it on my list of commits to be pushed out to 38-stable right 
> away. Does that make sense?

Yes, that will be great. Thanks!

Henrik
