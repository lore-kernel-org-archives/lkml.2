Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1CIJpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:45:54 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:58021 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689Ab1CIJpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:45:52 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 10:47:48 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] hid-multitouch: migrate 3M PCT touch screens to the
 unified driver.
Message-ID: <20110309094748.GB3980@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-4-git-send-email-benjamin.tissoires@enac.fr>
 <20110309084645.GB3569@polaris.bitmath.org>
 <AANLkTi=LHwdvpJOyeVqHrpFjikr5=uKsaa_T3LKgXtDP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=LHwdvpJOyeVqHrpFjikr5=uKsaa_T3LKgXtDP@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxFx0-0007JJ-5v.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxFx0-0007JJ-5v 73968ccc145d374d8cc8e203edfbd17a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:13:55AM +0100, Benjamin Tissoires wrote:
> Hi Henrik
> 
> On Wed, Mar 9, 2011 at 09:46, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Hi Benjamin,
> >
> > On Tue, Mar 08, 2011 at 05:32:58PM +0100, Benjamin Tissoires wrote:
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> >> ---
> >
> > Semms this patch is missing a commit message.
> 
> You can copy/paste this point to the other patches as well.
> 
> How about:
> "3M PCT touch screens can be handled by the unified driver. This will
> ease future evolution. So, just move it."
> 
> Then I'll copy/paste for the others.

I bet every driver merge has its own considerations that deserve
comment. A good commit message gives an introduction to the code
change and gives some context to the reader. Richard made a nice one
for the egalax driver.

Henrik
