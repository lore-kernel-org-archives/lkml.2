Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2JHOm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:42:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2JHOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:42:54 -0400
Date: Mon, 8 Oct 2012 16:42:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        =?ISO-2022-JP?Q?=1B$BN-2E=3DY=1B=28J?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification
 implementation
In-Reply-To: <CAN+gG=FOnFDn4BdEQUt0dbQRj-6PrhRzSOqM620xSM3DeTXt_Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210081642080.28357@pobox.suse.cz>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com> <20121006220421.47f5fd56@endymion.delvare> <6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr> <20121006231111.6350c014@endymion.delvare> <alpine.LNX.2.00.1210062314110.27782@pobox.suse.cz>
 <alpine.LNX.2.00.1210062326150.27782@pobox.suse.cz> <914C6C58-5A3B-4F7D-94BE-EF6868ED5D9D@enac.fr> <CAN+gG=FOnFDn4BdEQUt0dbQRj-6PrhRzSOqM620xSM3DeTXt_Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, Benjamin Tissoires wrote:

> It seems that hid transport layers should go in drivers/hid.
> However, I don't like mixing the transport layer and the final
> drivers. Maybe this is the time to rework a little bit the tree.
> To minimize the moves, we could introduce:
> drivers/hid/busses/usb
> drivers/hid/busses/i2c
> drivers/hid/busses/bluetooth

Something like that, I would personally like. But I am not going to 
forcefully take it over without bluetooth guys agreeing on that as well.

-- 
Jiri Kosina
SUSE Labs
