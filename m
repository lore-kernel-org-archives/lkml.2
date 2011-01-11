Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1AKRl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:41:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:46711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab1AKRl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:41:56 -0500
Date: Tue, 11 Jan 2011 18:41:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hid-multitouch: changes from the review process
In-Reply-To: <20110111173511.GA3461@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1101111841130.26685@pobox.suse.cz>
References: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr> <20110111173511.GA3461@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Henrik Rydberg wrote:

> On Tue, Jan 11, 2011 at 04:45:54PM +0100, Benjamin Tissoires wrote:
> > * amended Kconfig (PixCir and Hanvon are the same panel but with
> >   different name)
> > * insert field name in mt_class and retrieving it in mt_probe
> > * add 2 quirks: MT_QUIRK_VALID_IS_INRANGE, MT_QUIRK_VALID_IS_CONFIDENCE,
> >   in order to find the field "valid"
> > * inlined slot_is_contactid and slot_is_contact_number
> > * cosmetics changes (tabs and comments)
> > * do not send unnecessary properties once the touch is up
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> 
> There are some syntactic suboptimalities in the resulting file that
> perhaps could be fixed, but content-wise, I have nothing further. So,
> given that it actually works,
> 
> Acked-by: Henrik Rydberg <rydberg@euromail.se>

Guys, thanks a lot for your quick turnaround on this patchset.

I have applied the fixup patch, and will be merging to Linus tonight or 
tomorrow.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
