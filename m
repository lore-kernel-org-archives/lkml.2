Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1A1ReO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:34:14 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:58589 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab1A1ReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:34:13 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 28 Jan 2011 18:33:55 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] input: mt: Add method to extract the MT slot state
Message-ID: <20110128173355.GD2586@polaris.bitmath.org>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
 <1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
 <20110127120603.GB15626@polaris.bitmath.org>
 <AANLkTim7DbxhEO7vHPFcC1PFf=d2mSEyL+wurzUQa0pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7DbxhEO7vHPFcC1PFf=d2mSEyL+wurzUQa0pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PisBw-0004qY-AJ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PisBw-0004qY-AJ dc4d65fec712231387fe81bf5008b718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 01:49:18PM +0100, Benjamin Tissoires wrote:
> Hi Henrik,
> 
> On Thu, Jan 27, 2011 at 13:06, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Hi Benjamin,
> >
> > On Thu, Jan 27, 2011 at 11:35:46AM +0100, Benjamin Tissoires wrote:
> >> This patch adds the function input_mt_get_abs_value(), which may be
> >
> > Ehm, input_mt_get_absinfo?
> 
> In fact, the idea was to put this on the table again ;). I have no
> idea of what is the right think to do in such case.
> So I'll take all comments.
> 
> >
> >> used to extract the current state of the MT slots.
> >>
> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >
> > I had rather re-add this myself, thanks.
> 
> That was my question. Plus I had a subliminal message in which I
> intend you to take the drive on this work. ;)

Thanks for the patches, Benjamin, perhaps they do need a bit of
rewrite or a new ioctl. We will see what happens.

Thanks,
Henrik
