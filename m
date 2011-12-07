Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1LGJ1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:27:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1LGJ1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:27:46 -0500
Date: Wed, 7 Dec 2011 10:27:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: oneukum@suse.de, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] usb/hid-core: drain URB queue when going to
 suspend
In-Reply-To: <CAGS+omBvSWz4vBsMDkwk3oge_+k64tqSkrHyF5-C5_LZte_hDw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1112071026440.21970@pobox.suse.cz>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <CAGS+omBvSWz4vBsMDkwk3oge_+k64tqSkrHyF5-C5_LZte_hDw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Daniel Kurtz wrote:

> > In some situations, trying to suspend a laptop with an attached USB keyboard
> > would fail if both NumLock and CapsLock LEDs were lit.
> > This was due to a race condition between asynchronously submitted
> > LED-manipulating CTRL URBs and the suspend process.
> >
> > This is a different solution to the same problem highlighted here:
> > https://lkml.org/lkml/2011/9/2/391
> >
> > These patches are against Jiri's hid/for-next branch.
> >
> > Daniel Kurtz (3):
> >  HID: usbhid: remove LED_ON
> >  HID: usbhid: hid-core: submit queued urbs before suspend
> >  HID: usbhid: defer LED setting to a workqueue
> >
> > Differences since v1:
> >  * Rebase on hid/for-next
> >  * Solve race with usbhid_stop() [reported by Oliver Neukum]
> >
> 
> Hi Jiri,
> 
> Any chance you can take a look at this patch set?

Hi Dan,

it's still in my queue, sorry for delay; it absolutely hasn't been lost, I 
just haven't gotten to it yet.

Oliver, did you have a chance to review it, please? I'd apprecite your 
eventual Ack on this.

Thanks,

-- 
Jiri Kosina
SUSE Labs
