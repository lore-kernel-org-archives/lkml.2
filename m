Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2EVWAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:00:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab2EVWAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:00:47 -0400
Date: Wed, 23 May 2012 00:00:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
In-Reply-To: <4FBB5D4C.9090804@redhat.com>
Message-ID: <alpine.LNX.2.00.1205230000070.30445@pobox.suse.cz>
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com> <4FBB469B.50801@suse.cz> <4FBB49CE.9020408@redhat.com> <4FBB4E51.6020607@suse.cz> <4FBB5D4C.9090804@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Hans de Goede wrote:

> Well then lets work towards making it guaranteed, since I still believe
> the following holds true:
> 1) drvdata is for a driver to store a pointer to driver specific data
> 2) If no driver is bound, there is no driver specific data associated with
>    the device
> 3) Thus logically drvdata should be NULL if no driver is bound.
> 
> I'll do a patch for the USB-core to ensure that intfdata gets set to NULL
> on probe failure.

Hans,

I believe this is a good thing per se, but shouldn't this rather be done 
in driver core, to guarantee that this hold across all buses?

Thanks,

-- 
Jiri Kosina
SUSE Labs
