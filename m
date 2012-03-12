Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2CLP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:57:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2CLP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:57:51 -0400
Date: Mon, 12 Mar 2012 16:57:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
In-Reply-To: <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
Message-ID: <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>  <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz> <20120308105737.GA11201@polaris.bitmath.org>
 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Stéphane Chatty wrote:

> > What if we were to change the definition of a HID device on the
> > modalias level?
> > 
> > In practise, a HID device can be either an usb device, a hid device,
> 
> Just to be sure: do you mean "bluetooth device"? or is there such a 
> thing as a hid device per se? I'm asking because I've always been 
> surprised at seeing usbhid/ in hid/, which kind of breaks the potential 
> symmetry between USB and Bluetooth wrt hid.

Please don't get confused by the directory layout ... this has mostly 
non-technical reasons -- Marcel wanted to keep bluetooth/hidp under his 
wings, and I didn't have reasons to object strongly.

I am adding Marcel and Gustavo to CC just in case they have changed their 
mind, but it's definitely a side-topic in this discussion.
Marcel, Gustavo -- if you are interested in the whole discussion regarding 
potential extension of HID core infrastructure to better suit multitouch, 
please see the whole thread at http://marc.info/?t=133105322800006&r=1&w=4

-- 
Jiri Kosina
SUSE Labs
