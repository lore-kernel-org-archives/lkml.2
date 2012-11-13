Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2KMShm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:37:42 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:38094 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2KMShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:37:41 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjmxAGGRolBV5h1yPGdsb2JhbABEhTEjhQC4JgIBfhkBAQEBHxkNJ4IeAQEEATocIwULCANGFCUKGogXCqolkDAUjQ+BfoJ8YQOVe4V7g06Jaw
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="445286468"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 19:43:57 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] HID: hid-multitouch: forwards ABS_SCAN_TIME
Message-ID: <20121113184357.GA3635@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-14-git-send-email-benjamin.tissoires@gmail.com>
 <50A25990.6040302@gmail.com>
 <20121113172711.GA856@polaris.bitmath.org>
 <CAN+gG=HdOqVu1M2pycMZUBd4Z7wK9Bx=NLkCaaFwFie1-E3tdQ@mail.gmail.com>
 <20121113182825.GA3627@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113182825.GA3627@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To conclude, we obviously have devices with a rather short wrap-around
> time. However, since the normal inter-frame time is in the millisecond
> range, it should not be overly restrictive to change the definition of
> the minimum wraparound time from hours to seconds.

Sorry, Benjamin, you are right about the counter. To be useful, we do
need to know the number of bits of the counter, so that differences
can be computed properly. In other words, either ABS_SCAN_TIME is
be the better choice, or we need to make sure that the counter wraps
on the full 32 bit boundary.

Henrik
