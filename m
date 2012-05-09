Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892Ab2EITlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:41:15 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:51739 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879Ab2EITlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:41:09 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsO4AO/Fqk9V5qg+PGdsb2JhbABEijemZwF3AwGBIhkBAQEBHhkNJ4IMAQEEATocIxAIA0YUJQoaiBwJu34TizyBa4MBYwSVfIYGg1SJUw
X-IronPort-AV: E=Sophos;i="4.75,559,1330902000"; 
   d="scan'208";a="331931227"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 May 2012 21:46:23 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from
 logical_max value
Message-ID: <20120509194623.GA12381@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
 <20120506190322.GB12571@polaris.bitmath.org>
 <CAN+gG=HQ_U5dhVvgLu0zfMjv1+SAVB2Rx8fNq8tLX2DUHOMa9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HQ_U5dhVvgLu0zfMjv1+SAVB2Rx8fNq8tLX2DUHOMa9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> >> Win8 devices are required to present the feature "Maximum Contact Number".
> >> If the current value is 0, then, the driver can get the actual supported
> >> contact count by seeing the logical_max.
> >
> > And for win7, it is zero?
> 
> Well, the truth is that the Win8 specification formally describes the
> values here. And to get the certification, hardware makers have to put
> the right value in logical_max.
> TBH, I don't care that much now with win7 devices. Most of them are a
> piece of crap (not true dual fingers, problems in hid reports
> descriptors, etc...), but they just work (we made the necessary
> things). With the introduction of Win8, hardware makers will have to
> *certify* their devices, and thus, the Win8 driver is much less
> tolerant. I really think that we are going to see more and more win8
> devices, whereas win7 devices will fade out.
> 
> I had to add this patch because I have a win8 device that has the
> value associated to this field at 0, and it's the first I saw with
> this behavior.

As long as all existing devices are unaffected, it's fine, hence the question.

Thanks,
Henrik
