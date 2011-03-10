Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1CJQU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:20:26 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47285 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab1CJQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:20:24 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Mar 2011 17:16:35 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
Message-ID: <20110310161635.GA23223@polaris.bitmath.org>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1103011702240.32580@pobox.suse.cz>
 <AANLkTikd67q_j_ySam7RZvau8WoESLEmdXkfCWerVrLp@mail.gmail.com>
 <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxiUg-0001L8-9h.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PxiUg-0001L8-9h 83d96feb50ebe0374108818c8b70487e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:26:41PM +0100, Jiri Kosina wrote:
> On Tue, 1 Mar 2011, Benjamin Tissoires wrote:
> 
> > Tested-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
> > Acked-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
> 
> Applied, thanks.

Hi Jiri,

I was wondering if this patch will appear in the final 2.6.38? It
seems the regression it fixes is pretty severe for ntrig devices, and
once out there, the callback argument change will create problems for
add-on modules such as dkms modules.

Thanks,
Henrik
