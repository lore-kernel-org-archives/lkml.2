Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1ALOOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:14:06 -0500
Received: from csmtp1.one.com ([195.47.247.21]:49716 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1ALOOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:14:05 -0500
From: "Henrik Rydberg" <rydberg@bitmath.org>
Date: Wed, 12 Jan 2011 15:13:41 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hid-multitouch: changes from the review process
Message-ID: <20110112141341.GA31794@polaris.bitmath.org>
References: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr>
 <20110111173511.GA3461@polaris.bitmath.org>
 <AANLkTin86WMvEpNAm2T8wR=GgUBtYqoqGJxZm7hKnEoE@mail.gmail.com>
 <20110112122741.GA29373@polaris.bitmath.org>
 <AANLkTimnY3QC+7tsGhHi8awkMYQTDH8ugn4U--qkmup4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimnY3QC+7tsGhHi8awkMYQTDH8ugn4U--qkmup4@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Regarding the quanta patches you have pending, IFAICT the 0408:3001
> > device is not properly supported currently, so perhaps that one could
> > be added to the list, too.
> >
> 
> Hi Henrik,
> 
> What do you mean by not properly supported?

Buggy :-)

> the device is in hid-quanta since 2.6.33: commit "HID: add support for
> Pixart Imaging Optical Touch Screen"

The bug report has been around a while, I just assumed it was part of
your coming patches. No worries if it isn't.

Thanks,
Henrik

