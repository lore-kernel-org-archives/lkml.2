Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0JHRDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:03:04 -0400
Received: from mail.atheros.com ([12.19.149.2]:57878 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0JHRDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:03:01 -0400
Date: Fri, 8 Oct 2010 10:02:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Firmware versioning best practices: ath3k-2.fw rename or replace
 ath3k-1.fw ?
Message-ID: <20101008170258.GJ10149@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suraj,

What is the difference between ath3k-2.fw and ath3k-1.fw ?

Won't the API change now that you are addressing the sflash
configuration fix? Would it not help to identify the two
different firmwares then?

David, Marcel, what are your preferences for a firmware upgrade
where the firmware does not change API (lets just pretend it does
not for a moment) ? Do we keep the same filename?

In this particular case I would assume our new sflash configuration
fix that might be being worked on might change the re-enumerated
USB device IDs so it seems to me a good idea to use a new filename.
I should note ath3k-2.fw already made it to linux-firmware.git...

I last tried to document a thread we had over this here:

http://wireless.kernel.org/en/developers/Documentation/firmware-versioning

Does this sound sane? If so then the sflash configuration fix
would seem to me like it would require a new filename. Now, while
we're at it, how about bug fixes?

Suraj -- keep these discussions public please....

  Luis
