Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1CIIjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:39:53 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60339 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1CIIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:39:52 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 09:42:22 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110309084222.GA3569@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxEvp-0007vt-4T.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxEvp-0007vt-4T 0ca16d0880921ab3d3c12d8626f50f31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This patch enables support of autodetection of maxcontacts.
> We can still manually provide maxcontact in case the device
> lies on it.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

It seems quite alright to let the classes contain the expected number
of contacts, so I do not really see the reason for that part of the
patch. How about keeping the maxcontacts in the class, and then do
max(hid-provided-maxcontacts, default-maxcontacts)?

Thanks,
Henrik
