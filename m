Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0IGCtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:49:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35179 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab0IGCtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mP0tq922h1c1QtKSzuYWxKG0MdYK1Voq3+C6Uf3ZX07fid9rCmDpv/58aJe2QmeQtV
         N3aGUmf0DxvVhuiF3D3s6pTq+bj8ESqzY2gTlS7udFBzV2CeJghx89nc5nPfXj6pzwJi
         OPs8fEc1NopwdeDqtMVbB4kJwNFlvyyN6QCdc=
MIME-Version: 1.0
In-Reply-To: <0dfed6f7fe2c07da3ce8108a4c5620c3@secure211.sgcpanel.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<0dfed6f7fe2c07da3ce8108a4c5620c3@secure211.sgcpanel.com>
Date: Tue, 7 Sep 2010 11:49:38 +0900
Message-ID: <AANLkTinGSXdfWBABm9dmGDxnbf-_udg0ZvVCyH8FX-aO@mail.gmail.com>
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

Venkii.

On Tue, Sep 7, 2010 at 5:22 AM, Felipe Balbi <me@felipebalbi.com> wrote:
> Hi,
>
> On Tue, 7 Sep 2010 03:10:30 +0900, venki kaps <venkiece2005@gmail.com>
> wrote:
>> Dear USB experts,
>>
>>   Is the same fix valid for omap3430 + 2.6.32 Kernel?
>
> 3.6.32 ?? difficult to say. Why such an old kernel ? Although
> I doubt musb or twl4030-usb driver has changed that much, it's
> difficult to say.
>
>>   I have been facing mp3 playback idle current consumption 20mA more
>> after booting without USB cable connected
>
> let me see if I understand you right. The consumption is higher
> when the cable is kept plugged or the consumption is higher if
> you boot with usb cable pugged and remove it afterwards ?
  >> The consumption is higher if boot without usb cable.If boot when
the cable is kept plugged
  >> and remove it afterwards, then normal.
>
> --
> balbi
>
