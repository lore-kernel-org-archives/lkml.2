Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2HHBJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:09:01 -0400
Received: from wdmail02.wdc.com ([129.253.55.42]:21158 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2HHBI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:08:57 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 21:08:56 EDT
X-IronPort-AV: E=Sophos;i="4.77,730,1336374000"; 
   d="scan'208";a="2688844"
From: Daniel Taylor <Daniel.Taylor@wdc.com>
To: "'Bernd Petrovitsch'" <bernd@petrovitsch.priv.at>
CC: "'Alan Stern'" <stern@rowland.harvard.edu>,
        Pavel Vasilyev <pavel@pavlinux.ru>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: RE: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
Thread-Topic: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
Thread-Index: AQHNc71OqfXYmT8bKE+m49hTuojI3JdNT7qAgAAXZYCAAAfJgIAAJusAgAAUDoD//7v3YIABZqeAgABOD5A=
Date: Wed, 8 Aug 2012 00:59:24 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A2FD890B3@wdscexmb03.sc.wdc.com>
References: <50201156.30704@pavlinux.ru>
	 <Pine.LNX.4.44L0.1208061556010.1649-100000@iolanthe.rowland.org>
	 <5A9BC72FD5CEC94EA024CED8E31D701A2FD84FC0@wdscexmb03.sc.wdc.com>
 <1344345590.3975.1.camel@thorin>
In-Reply-To: <1344345590.3975.1.camel@thorin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.44.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Said it was a silly question.

It's funny.

I've been using "0123456789abcdef"[index] for a long time, so I "know"
that "string" is a array of char, but it never occurred to me that
"string" would work in sizeof() the same way as

char string[] = { '0', '1', '2', '3', '4', '5', '6', '7',
                  '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', '\0' };

int stringlength = sizeof(string);

Learned something.

Thanks,

Dan
 

> -----Original Message-----
> From: Bernd Petrovitsch [mailto:bernd@petrovitsch.priv.at] 
> Sent: Tuesday, August 07, 2012 6:20 AM
> To: Daniel Taylor
> Cc: 'Alan Stern'; Pavel Vasilyev; Pavel Machek; Len Brown; 
> linux-acpi@vger.kernel.org; 
> linux-pm@lists.linux-foundation.org; 
> linux-kernel@vger.kernel.org; Len Brown
> Subject: RE: [linux-pm] [PATCH] ACPI: replace 
> strlen("string") with sizeof("string") -1
> 
> On Mon, 2012-08-06 at 22:57 +0000, Daniel Taylor wrote:
> > Silly question:  when did sizeof("string") get changed to 
> be anything
> > other than the size of the pointer ("string" is, after all, an array
> > of characters)? 
> 
> It is since K&R times that way.
> If you do not know the difference between a pointer and an array (and
> these are vastly different), go learn something new about C.
> 
> 	Bernd
> -- 
> Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
>                      LUGA : http://www.luga.at
> 
> 