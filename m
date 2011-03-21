Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1CUKbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:31:47 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:54778 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab1CUKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:31:45 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 11:34:47 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
Message-ID: <20110321103447.GA1734@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-6-git-send-email-benjamin.tissoires@enac.fr>
 <20110321090533.GE3784@polaris.bitmath.org>
 <AANLkTinAPFnHA=MWbb=Yu7U0AXrxHv2-95M=OequsAL7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinAPFnHA=MWbb=Yu7U0AXrxHv2-95M=OequsAL7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1cO5-0007Gl-Bw.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Q1cO5-0007Gl-Bw 26d389003785fa08dc3385c9eb9678cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 11:13:46AM +0100, Benjamin Tissoires wrote:
> On Mon, Mar 21, 2011 at 10:05, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Hi Benjamin,
> >
> > On Fri, Mar 18, 2011 at 02:27:56PM +0100, Benjamin Tissoires wrote:
> >> This patch merges the hid-3m-pct driver into hid-multitouch.
> >> To keep devices working the same way they used to with hid-3m-pct,
> >> we need to add two signal/noise ratios for width and height.
> >> We also need to work on width/height to send proper
> >> ABS_MT_ORIENTATION flag.
> >>
> >> Importing 3M into hid-multitouch also solved the bug in which
> >> devices handling width and height in their report descriptors
> >> did not show ABS_MT_TOUCH_MAJOR and ABS_MT_TOUCH_MINOR.
> >>
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> >> Reviewed-by: Stéphane Chatty <chatty@enac.fr>
> >> ---
> >
> > The patch _looks_ good, but I have problems getting this to work on a
> > 3M2256. What devices were this one tested on so far?
> 
> Hi Henrik,
> 
> I tested it against 3M1968. I'll try to have it again to make more testing.
> What symptoms do you have?

I think it is the input mode setting, but I am not sure yet.

Thanks,
Henrik
