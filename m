Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2HGNo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:44:56 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2647 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab2HGNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:44:54 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 09:44:54 EDT
Subject: RE: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        Pavel Vasilyev <pavel@pavlinux.ru>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Date: Tue, 07 Aug 2012 15:19:47 +0200
In-Reply-To: <5A9BC72FD5CEC94EA024CED8E31D701A2FD84FC0@wdscexmb03.sc.wdc.com>
References: <50201156.30704@pavlinux.ru>
	 <Pine.LNX.4.44L0.1208061556010.1649-100000@iolanthe.rowland.org>
	 <5A9BC72FD5CEC94EA024CED8E31D701A2FD84FC0@wdscexmb03.sc.wdc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344345590.3975.1.camel@thorin>
Mime-Version: 1.0
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 22:57 +0000, Daniel Taylor wrote:
> Silly question:  when did sizeof("string") get changed to be anything
> other than the size of the pointer ("string" is, after all, an array
> of characters)? 

It is since K&R times that way.
If you do not know the difference between a pointer and an array (and
these are vastly different), go learn something new about C.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

