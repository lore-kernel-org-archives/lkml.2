Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2D3SJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:09:46 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:51121 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2D3SJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:09:44 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjV8AIrUnk9V5qnhPGdsb2JhbABEiiqlJoFhBIEaGQEBAQEeGQ0nggkBAQQBOhwjBQsIA0YUDRgKGhOHfwMGCbBbDYlTE4l5gSiFC2MElX2GBoU6h20
X-IronPort-AV: E=Sophos;i="4.75,506,1330902000"; 
   d="scan'208";a="324229716"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 30 Apr 2012 20:14:06 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid-logitech: Collect report descriptors before
 sending
Message-ID: <20120430181406.GA3313@polaris.bitmath.org>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
 <1335097300-11881-3-git-send-email-rydberg@euromail.se>
 <CAE7qMrqEJmBWo7JDHuB2DnWJ4vkvv9jya7RDJguiXsrs2xgadQ@mail.gmail.com>
 <CAN+gG=EDbtZkRZ+zr6awvK8fDYdV-c59On8B3O=vSMYhdQs_cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EDbtZkRZ+zr6awvK8fDYdV-c59On8B3O=vSMYhdQs_cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been able to test the changes with different Logitech mice and keyboards.
> 
> So Jiri,
> Tested-By: Benjamin Tissoires <benjamin.tissoires@gmail.com
> for this change and this patch and the 3rd one (Hid: Handle
> driver-specific device descriptor in core).

Thanks, Benjamin.

Henrik
