Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab1INRAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:00:14 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:60406 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab1INRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:00:12 -0400
Date: Wed, 14 Sep 2011 19:00:09 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        rtitmuss@logitech.com, ogay@logitech.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jean-Daniel Zanone <jzanone@logitech.com>
Subject: Re: [PATCH v4] HID: Add full support for Logitech Unifying receivers
Message-ID: <20110914170009.GB1623@x4.trippels.de>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
 <20110910072826.GA1611@x4.trippels.de>
 <CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com>
 <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.09.14 at 18:45 +0200, Benjamin Tissoires wrote:
> I got some information for you. Apparently, it won't be possible to
> enable this thumb button right now.
> To enable it, the Windows driver put the mouse in a kind of debug mode
> that need to be handled properly, which is not the case as of today.

Understood. But all we need to know is the magic bytes to send to the
controller to enable the thumb-button. And because it works without
problems under Windows, it shouldn't be impossible to implement in
Linux. Maybe the Logitech guys could cook something up?

Thanks.

-- 
Markus
