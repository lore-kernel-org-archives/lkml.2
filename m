Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0IGNSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:18:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45354 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0IGNSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pEr4FD0rLoUsW3+z0K2b8wST+FppomCjkAjMsutTvjIOi11864cAgu+2uYrTpwRV74
         U2hD213CjINHrV3QXgSjutFSx550+xsLDpeJNcvj9ZqDLAX0HcaKCmJPvY3+O8lKODTu
         5Y1bwCknZr4VW5rwiCTzELK42E88HLOlVHSlw=
MIME-Version: 1.0
In-Reply-To: <e07f55b5f77ea471f41353190431bc78@secure211.sgcpanel.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<0dfed6f7fe2c07da3ce8108a4c5620c3@secure211.sgcpanel.com>
	<AANLkTinGSXdfWBABm9dmGDxnbf-_udg0ZvVCyH8FX-aO@mail.gmail.com>
	<e07f55b5f77ea471f41353190431bc78@secure211.sgcpanel.com>
Date: Tue, 7 Sep 2010 18:48:35 +0530
Message-ID: <AANLkTik8m2hzWCdFaVxRmv-5f=Sv5nPo1rs7PKK8CCVS@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: venki kaps <venkiece2005@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: tom.leiming@gmail.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Anand Gadiyar <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkii,
On Tue, Sep 7, 2010 at 6:16 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> Hi,
>
> On Tue, 7 Sep 2010 11:49:38 +0900, venki kaps <venkiece2005@gmail.com>
> wrote:
>>> let me see if I understand you right. The consumption is higher
>>> when the cable is kept plugged or the consumption is higher if
>>> you boot with usb cable pugged and remove it afterwards ?
>>   >> The consumption is higher if boot without usb cable.If boot when
>> the cable is kept plugged
>>   >> and remove it afterwards, then normal.
>
> ok, so that's what I had observed and my original patch is the one
> you want. You probably _also_ want this one though due the WARN
  >>> Is WARN_ON created issue? or
  >>> As you mentioned earlier, if (!regulator_is_enabled(twl->usb3v1)
regulator_enable(twl->usb3v1); would be required?
  >>> could you please provide more details?
>
> --
> balbi
>
