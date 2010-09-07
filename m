Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0IGKsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:48:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44417 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0IGKsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:48:47 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
CC: Greg KH <gregkh@suse.de>, David Brownell <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Sep 2010 16:18:23 +0530
Subject: RE: [PATCH] USB: Fix kernel oops with g_ether and Windows
Thread-Topic: [PATCH] USB: Fix kernel oops with g_ether and Windows
Thread-Index: ActOdSI6LZkDh3ZFSNSkbel8nvuXbwABIibQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
	<5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com>
	<20100906201852.GB5162@suse.de>	<4C860C21.40708@ru.mvista.com>
 <AANLkTins336XV97o=72YdqLf1Gr_hA9NjMNqcaWDosfK@mail.gmail.com>
In-Reply-To: <AANLkTins336XV97o=72YdqLf1Gr_hA9NjMNqcaWDosfK@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o87AnGhx006203

Maxim Osipov wrote:
> On Tue, Sep 7, 2010 at 1:55 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> >
> > Â  It was caught by me on the list too, right at the same day the patch was
> > posted. The author remained silent though...
> >

Sorry Sergei, I seem to have missed your mail on the list, and didn't
bother hunting in the list archives.

> 
> Sorry for being silent - I had lots of things to do. Regarding the
> patch itself - I respect kernel coding conventions, but I think it is
> bad to have two different code styles in one file. Note, this is my
> personal opinion only.
> 

I should have looked closer - I see now that you've only retained
the existing style.

Since Greg has already sent a pull request, I won't touch the file
now; maybe a trivial patch later on to fix up the coding style.

- Anand
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
