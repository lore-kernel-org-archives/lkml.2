Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2A0JMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:12:13 -0500
Received: from mail2.nsc.com ([12.238.8.132]:58649 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029Ab2A0JMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:12:09 -0500
X-WSS-ID: 0LYG9K4-0A-3EM-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>
Date: Fri, 27 Jan 2012 01:12:00 -0800
Subject: RE: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Topic: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Index: AczchMjYacxwynU7RZKqa+mKdJrzuQAEa/nAAA6Yu+A=
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EBA0@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3EE5@EXMAIL03.scwf.nsc.com>
 <20120126154651.767c4e55.akpm@linux-foundation.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633CB5E81LS9967290-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I had a few little problems here.
> >
> > - For some reason my email client doesn't like MIME quoted-printable
> >   and cannot correctly extract the plain text.  It appears that
> >   globally deleting =\n and globally replacing =3D with = fixes
> things.
> >   Ho hum.  I really should go see if this has been fixed, or hassle
> >   the sylpheed developer(s).
> >
> > - The driver generates a great storm of scripts/checkpatch.pl
> >   whitespace warnings.  Things like using eight spaces instead of a
> >   tab.  These really should be fixed, so please take a look at the
> >   checkpatch output then resend?
> 
 
> But for the whitespace problem, I'm afraid something wrong in my mail
> client - outlook 2007.
> Patch mail sent from myself has normal tab indentation with plain text.
> But in notice mail from akpm, all tabs were replaced with 8 spaces !
> 

It seems that tab-replacement problem is related with the size of text in my email client.
So lp855x driver split into three patches. And it looks fine.

Please refer to '[PATCH v3]' for new lp855x driver.
Title : 
[PATCH v3 1/3] backlight: new backlight driver for LP855x devices
[PATCH v3 2/3] backlight: new backlight driver for LP855x devices
[PATCH v3 3/3] backlight: new backlight driver for LP855x devices

Thanks & BR
Milo -

