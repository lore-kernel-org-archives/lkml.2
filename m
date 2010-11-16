Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab0KPHDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:03:45 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:33680 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933886Ab0KPHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:03:43 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 544CC3070C
Date: Tue, 16 Nov 2010 08:03:40 +0100 (CET)
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: jkosina@suse.cz, gregkh@suse.de
Cc: erazor_de@users.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <640538250.3216351289891020338.JavaMail.ngmail@webmail08.arcor-online.net>
In-Reply-To: <alpine.LNX.2.00.1011152330540.7420@pobox.suse.cz>
References: <alpine.LNX.2.00.1011152330540.7420@pobox.suse.cz> <1289853161.2188.44.camel@neuromancer> <20101115220828.GA9417@suse.de>
Subject: Aw: Re: [PATCH 0/3] HID: roccat: finishing usage of
 sysfs_create_bin_group()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 138.246.2.174
X-Arcor-Original-Account: screamingfist@arcor.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 15 Nov 2010, Greg KH wrote:
> 
> > > These patches are against the newest roccat file versions (after
> > > applying everything I released the last days).
> > > They fix some inattentive (though not critical) failures from previous
> > > patches and change hid-roccat-koneplus and hid-roccat-pyra to use the
> > > new sysfs_create_bin_group()
> > > koneplus should be finished now (until I find errors)
> > 
> > Wait, they still don't resolve the main problem of this api is still
> > racy and I can't accept it.
> 
> Yeah, I have already pointed Stefan to
> 
> 	 http://lkml.org/lkml/2010/11/13/174
> 
> which he might have missed.

Hello again,

I don't see why these patches can't be applied. The bin attribute group functions standing for themself seem to be useful. The kone driver is already in the stable kernel and has less code with these patches. Though this does not change its functionality its a code cleanup. Thats also true for pyra and koneplus. So for me these are clear improvements until I make progress in the race problem. I will do it, but being a newbe I don't know where to start (feel free to point me to something), so it might take quite some time and sure needs some questions asked.

Have a nice day
Stefan
