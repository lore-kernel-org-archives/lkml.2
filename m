Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1CUNqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:46:42 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:34462 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab1CUNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:46:39 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 14:50:13 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] hid-multitouch: refactor initialization of
 ABS_MT_ORIENTATION
Message-ID: <20110321135013.GB3363@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-5-git-send-email-benjamin.tissoires@enac.fr>
 <20110321090240.GD3784@polaris.bitmath.org>
 <AANLkTimx6YR_ByHDeqyMmSuE659xyRNkaAoOffTp_RgC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimx6YR_ByHDeqyMmSuE659xyRNkaAoOffTp_RgC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1fRC-0000La-AC.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Q1fRC-0000La-AC 4d56f33bf875f77b74851165ab2c4bda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 02:32:16PM +0100, Benjamin Tissoires wrote:
> Hi Henrik,
> 
> On Mon, Mar 21, 2011 at 10:02, Henrik Rydberg <rydberg@euromail.se> wrote:
> > On Fri, Mar 18, 2011 at 02:27:55PM +0100, Benjamin Tissoires wrote:
> >> No semantic changes, it's just easier to read the code.
> >
> > Please augment this commit message.
> 
> How about:
> 
> "The way the input_set_abs_params was called for the new composite
> field ABS_MT_ORIENTATION was not very clear at second reading.
> We can remove the non-necessary call to set_abs and use the simple
> call to input_set_abs_params."

Sure thing. In addition, the old code was setting the hid parameters
for the wrong field, which was odd.

Thanks,
Henrik
