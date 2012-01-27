Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2A0CGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:06:33 -0500
Received: from mail2.nsc.com ([12.238.8.132]:59257 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751480Ab2A0CGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:06:32 -0500
X-WSS-ID: 0LYFPUS-0A-06P-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>
Date: Thu, 26 Jan 2012 18:06:14 -0800
Subject: RE: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Topic: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Index: AczchMjYacxwynU7RZKqa+mKdJrzuQAEa/nA
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6E9E6@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3EE5@EXMAIL03.scwf.nsc.com>
 <20120126154651.767c4e55.akpm@linux-foundation.org>
In-Reply-To: <20120126154651.767c4e55.akpm@linux-foundation.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633CD9111LS9962156-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, January 27, 2012 8:47 AM
> To: Kim, Milo
> Cc: linux-kernel@vger.kernel.org; Richard Purdie
> Subject: Re: [PATCH v2] backlight: new backlight driver for LP855x
> devices
> 
> On Tue, 24 Jan 2012 22:24:02 -0800
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
> 
> > This patch supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight
> driver.
> >
> > ...
> 
> I had a few little problems here.
> 
> - For some reason my email client doesn't like MIME quoted-printable
>   and cannot correctly extract the plain text.  It appears that
>   globally deleting =\n and globally replacing =3D with = fixes things.
>   Ho hum.  I really should go see if this has been fixed, or hassle
>   the sylpheed developer(s).
> 
> - The driver generates a great storm of scripts/checkpatch.pl
>   whitespace warnings.  Things like using eight spaces instead of a
>   tab.  These really should be fixed, so please take a look at the
>   checkpatch output then resend?

Thanks a lot for your notice.
In my side, 2 warnings and 2 errors are found after running checkpath.pl.
I'll resend the patch after fix as title : [PATCH v3].

------------------------------------------------------------------
The result of running checkpatch : lp855x.h
WARNING: please, no space before tabs
#28: FILE: linux/lp855x.h:28:
+#define LP8550_I2C_CONFIG ^I((ENABLE_BL << BL_CTL_SHFT) | \$

WARNING: please, no space before tabs
#46: FILE: linux/lp855x.h:46:
+#define LP8556_I2C_CONFIG ^I((ENABLE_BL << BL_CTL_SHFT) | \$

total: 0 errors, 2 warnings, 133 lines checked

The result of running checkpatch : lp855x_bl.c
ERROR: return is not a function, parentheses are not required
#134: FILE: video/backlight/lp855x_bl.c:134:
+	return (bl->props.brightness);

ERROR: return is not a function, parentheses are not required
#156: FILE: video/backlight/lp855x_bl.c:156:
+	return (bl->props.brightness);

total: 2 errors, 0 warnings, 331 lines checked
------------------------------------------------------------------

But for the whitespace problem, I'm afraid something wrong in my mail client - outlook 2007.
Patch mail sent from myself has normal tab indentation with plain text.
But in notice mail from akpm, all tabs were replaced with 8 spaces !

Thanks & BR
Milo -

