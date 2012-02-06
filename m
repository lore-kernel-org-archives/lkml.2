Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2BFMYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:24:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab2BFMYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:24:04 -0500
Date: Mon, 6 Feb 2012 13:24:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 0/3] Support of Perixx Peripad 701 for
 hid-multitouch
In-Reply-To: <20120206083909.GA3972@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1202061323430.24127@pobox.suse.cz>
References: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com> <20120206083909.GA3972@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, Henrik Rydberg wrote:

> > This is the v3 of the support of Perixx Peripad 701.
> > 
> > I included the changes asked by Henrik & Dmitry:
> > -           code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;
> > +           code =  BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);
> > use of min;
> > remove remove the call to input_mt_report_finger_count;
> > remove debug information;
> > some cosmetic changes (parenthesis, typos)
> 
> Looking good now, thanks.
> 
>     Acked-by: Henrik Rydberg <rydberg@euromail.se>

I have now applied the patchset. Thanks everybody.

-- 
Jiri Kosina
SUSE Labs
