Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768241Ab2KOPJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:09:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:6400 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768211Ab2KOPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:09:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,258,1352102400"; 
   d="scan'208";a="249564191"
From: "Blower, Melanie" <melanie.blower@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: PROBLEM: compilation issue, inline assembly
 arch/x86/kvm/emulate.c fails at -O0
Thread-Topic: PROBLEM: compilation issue, inline assembly
 arch/x86/kvm/emulate.c fails at -O0
Thread-Index: Ac3CnVCLy1S7HLd7SEaFDxv+y/0FtQAa+CWAAA55SGA=
Date: Thu, 15 Nov 2012 15:09:50 +0000
Message-ID: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17B2F7@FMSMSX107.amr.corp.intel.com>
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
 <50A433D3.6090301@zytor.com>
In-Reply-To: <50A433D3.6090301@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAFF9u8M030963

Thanks for your reply. As you agree there is an actual bug in this code, would you kindly be able to tell me when a fix would be available in the Linux trunk?
Thanks and best regards, Melanie Blower

-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Wednesday, November 14, 2012 7:14 PM
To: Blower, Melanie
Cc: tglx@linutronix.de; mingo@redhat.com; avi@redhat.com; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: compilation issue, inline assembly arch/x86/kvm/emulate.c fails at -O0

On 11/14/2012 11:45 AM, Blower, Melanie wrote:
> [1.] gcc -O0 assembly arch/x86/kvm/emulate.c gets compilation failure 
> -- incorrect register restrictions [2.] Full description of the problem/report:
> I'm trying to compile this file at -O0, but gcc chokes in register allocation at the inline assembly.
>
> In the ordinary Linux build, this file compiles with gcc at -O2, without compilation errors.

Compiling with -O0 is not really expected to work (although -O1 *is*), although what you are reporting is an actual bug ("+a" : "a" should either be "+a" or "=a" : "a").

	-hpa

--
H. Peter Anvin, Intel Open Source Technology Center I work for Intel.  I don't speak on their behalf.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
