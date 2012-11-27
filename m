Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2K0UTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:19:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab2K0UTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:19:49 -0500
Date: Tue, 27 Nov 2012 21:19:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] HID: hid-input: simplify hid_input allocation and
 registration
In-Reply-To: <20121127201407.GA884@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1211272118400.3933@pobox.suse.cz>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com> <1353684694-5723-3-git-send-email-benjamin.tissoires@gmail.com> <20121127201407.GA884@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Henrik Rydberg wrote:

> > In order to provide fine control for the creation of different
> > input devices in probe function of third party drivers, this patch
> > split the allocations, the registrations and the free of input
> > devices.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/hid-input.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> I don't like this patch, nor its purpose. Drivers should not depend on
> the hid core working in a particular way internally, that spells
> disaster. There must be some other way in which the same effect can be
> achieved?

The changelog doesn't seem to be really verbose enough to me.

What exactly is the scenario you are looking at here, Benjamin, please? 

Thanks,

-- 
Jiri Kosina
SUSE Labs
