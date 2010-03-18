Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0CRNjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:39:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35830 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0CRNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:39:24 -0400
Date: Thu, 18 Mar 2010 13:39:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add basic support for lm64 to
	lm63.c
Message-ID: <20100318133912.GA6714@srcf.ucam.org>
References: <1268855722-18457-1-git-send-email-mjg@redhat.com> <20100318084135.15fb1996@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318084135.15fb1996@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the dump from the lm64.

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 34 3e 00 03 08 46 00 46 00 03 08 46 00 46 00 00    4>.??F.F.??F.F..
10: 60 10 00 00 00 00 e5 00 00 7b 1f 1f 00 00 00 00    `?....?..{??....
20: 00 64 00 00 00 00 00 00 00 00 00 00 00 00 00 00    .d..............
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
40: 00 00 00 00 00 00 af 0f ff ff 00 00 05 08 00 05    ......??....??.?
50: 00 04 32 05 46 06 5a 07 5f 0b 64 0d 69 10 69 10    .?2?F?Z?_?d?i?i?
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
b0: c0 20 2a d1 19 01 0d 00 00 00 00 00 00 00 00 00    ? *????.........
c0: 00 00 00 00 00 00 00 27 00 00 00 00 00 00 00 02    .......'.......?
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 51    ..............?Q

-- 
Matthew Garrett | mjg59@srcf.ucam.org
