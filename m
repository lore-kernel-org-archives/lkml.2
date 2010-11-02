Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0KBI5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:57:50 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:31310 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0KBI5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:57:45 -0400
X-IronPort-AV: E=Sophos;i="4.58,279,1286164800"; 
   d="scan'208";a="24221660"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Drivers <Drivers@analog.com>,
        "rpurdie@linux.intel.com" <rpurdie@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Date: Tue, 2 Nov 2010 08:57:40 +0000
Subject: RE: [PATCH] video: backlight: adp8870: Fix warn_unused_result
 warning reported by Stephen Rothwell
Thread-Topic: [PATCH] video: backlight: adp8870: Fix warn_unused_result
 warning reported by Stephen Rothwell
Thread-Index: Act3nxKPFRbdlIWbSlObjXqiWUFKSwCyywow
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713094627148@LIMKCMBX1.ad.analog.com>
References: <1288364066-18709-1-git-send-email-michael.hennerich@analog.com>
 <20101029122534.d4d6a439.akpm@linux-foundation.org>
In-Reply-To: <20101029122534.d4d6a439.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2010-10-29:
>
> I have some bones to gnaw.  Not specific to this patch ;)
>
> On Fri, 29 Oct 2010 16:54:26 +0200
> <michael.hennerich@analog.com> wrote:
>
>> Subject: [PATCH] video: backlight: adp8870: Fix warn_unused_result
>> warning reported by Stephen Rothwell
>
> Lots of people are doing this "video: backlight: adp8870:" thing
> lately.  And it's good, but why not just use
> "drivers/video/backlight/adp8860_bl.c" to identify the affected
> susbsytem/file/etc?  It's simple and uniform.  It's not always the
> appropriate thing to do, but replacing the /'s with ": " seems rather
> random and pointless.

Think it's easier to read, or better skip reading further.

> Secondly, no, the point of this patch is not to fix a
> warn_unused_result() warning!  The patch actually fixes a bug: the
> code wasn't checking the strict_strtoul() return value.  The warning
> is simply what alerted us to the bug.
>
> So I renamed this patch to
>
>       drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return
> value

Agreed - Thanks for fixing it.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


