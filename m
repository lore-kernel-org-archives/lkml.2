Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1DMXba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:31:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55834 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab1DMXb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CYERaXWesq1eH0GnGbP+fBPHnPV0B80KWlQJwrwtL27nW6Py3rdRmsVpax+X5ucyDf
         x54VuNe5UGTb7XW93ch0SqHOxAZknDybXlCPUHsH5UcTPeKXMprCPVAyiHkt/QLlO+r5
         aM9TLz5AvyAWGFbk/WPuUy7RwzlFIhD7Avqsw=
MIME-Version: 1.0
In-Reply-To: <1302726187.7911.11.camel@dev.znau.edu.ua>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<4DA4AC4B.90409@hauke-m.de>
	<BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
	<BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
	<1302640546.14216.65.camel@dev.znau.edu.ua>
	<BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
	<op.vtvalzu33ri7v4@arend-laptop>
	<BANLkTik6JZ-n3sVjCFK_x1yNRH3_o3_6rg@mail.gmail.com>
	<1302726187.7911.11.camel@dev.znau.edu.ua>
Date: Thu, 14 Apr 2011 01:31:25 +0200
Message-ID: <BANLkTikR+Y=FwqO15iHhaA57NdfFi6-ykA@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/13 George Kashperko <george@znau.edu.ua>:
> Look brcm80211/inclue/aidmp.h for those.

Interesting, I found some register defines that hopefully should be
common/general:
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0344c/Bgbhedeg.html
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0344c/Cfacacha.html

-- 
Rafał
