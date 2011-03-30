Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1C3R2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:28:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:7765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab1C3R2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:28:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,269,1299484800"; 
   d="scan'208";a="903642791"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 30 Mar 2011 10:27:43 -0700
Subject: RE: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Topic: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Index: AcvtgL2TjsfrVMzWTV2TnjDKol/1HgBfgzCg
Message-ID: <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra> <20110324223907.GA10498@liondog.tnic>
 <4D8C6C80.8010600@redhat.com> <20110325141322.GB28313@gere.osrc.amd.com>
 <4D8D078C.1040201@redhat.com> <20110328170302.GF11590@aftab>
 <4D90E525.4030709@redhat.com>
In-Reply-To: <4D90E525.4030709@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2UHSNvK021137

> A INT13 persistent data saving will probably be too hard to implement for
> all kind of storages. So, it will probably need lots of hack in order to
> work. Also, some hardware may even not have any local hard disk. Not sure
> if it is worth to spend time on it.

Linus was pretty clear that he didn't like the idea when
it came up a few weeks ago in the:
 [PATCH 0/2][conceâ€‹pt RFC] x86: BIOS-save kernel log to disk upon panic
thread.

Linus ranted:
> Quite frankly, I'm not likely to _ever_ merge anything like this.
>
> Over the years, many people have tried to write things to disk on
> oops. I refuse to take it. No way in hell do I want the situation of
> "the system is screwed, so let's overwrite the disk" to be something
> the kernel I release might do. It's crazy. That disk is a lot more
> important than the kernel, and overwriting it when we might have
> serious memory corruption issues or something is not a thing I feel is
> appropriate.

I agree with him - writing to disk from a known broken kernel (using
a probably buggy BIOS) is a disaster waiting to happen to somebody's
disk.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
