Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2JaSnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:43:09 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:46041 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2JaSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:43:06 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiPBALJwkVBV5h1yPGdsb2JhbABEilG4AwICgQEZAQEBAR8ZDSeCHwEFJxMcIxAIA0YUJQoaiB27bhSMHoENhBNhA5V1hXmNOg
X-IronPort-AV: E=Sophos;i="4.80,688,1344204000"; 
   d="scan'208";a="142986811"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 31 Oct 2012 19:47:50 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/11] HID: hid-multitouch: support T and C for win8
 devices
Message-ID: <20121031184750.GA1740@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-7-git-send-email-benjamin.tissoires@gmail.com>
 <20121029220058.GB15413@polaris.bitmath.org>
 <CAN+gG=GRd6re056mn_C-UH0r8NgPiH98npxShMe3Ost_dcnzfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GRd6re056mn_C-UH0r8NgPiH98npxShMe3Ost_dcnzfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +                             usage_index) {
> >> +                             hid_map_usage(hi, usage, bit, max,
> >> +                                     EV_ABS, ABS_MT_TOOL_X);
> >> +                             set_abs(hi->input, ABS_MT_TOOL_X, field,
> >> +                                     cls->sn_move);
> >> +                     } else {
> >> +                             hid_map_usage(hi, usage, bit, max,
> >>                                       EV_ABS, ABS_MT_POSITION_X);
> >> -                     set_abs(hi->input, ABS_MT_POSITION_X, field,
> >> -                             cls->sn_move);
> >> +                             set_abs(hi->input, ABS_MT_POSITION_X, field,
> >> +                                     cls->sn_move);
> >> +                     }
> >> +
> >
> > Do we really want to do the latter several times, even if the device is not a win8 one?
> 
> I don't get your point here. The only difference with the previous
> release is that it will treat differently the first in the array than
> the others. For non win8 devices, there is no changes in the behavior.
> Could you elaborate a little bit more, please?

I was wondering what we want to do about multiple reports in the
general casel. Not that important though, the patch will probably look
fine in your next version.

Thanks,
Henrik
