Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1ECWpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:45:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50375 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1ECWpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JuScQt6AqIbtYsndbmghmbSMjmLnAG+P7d2nZf+HmURGodx3yXy9TL9gpAKwJiPzCl
         bf4huxHgbTD4vo1DxUSMEYiOY67lHIu46ywD1kiqBT8DBZDYbDoGKJQo6WilXgGG0qUi
         XehOTa8rHAPUXrnWPxt97OafE41yrkiiCEbso=
MIME-Version: 1.0
In-Reply-To: <710D4D6CE160654C87478D18385BB9971BE3FDCA5C@MDC-MAIL-CMS01.ubisoft.org>
References: <1304264799.2833.82.camel@localhost>
	<1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
	<1304370274.2833.192.camel@localhost>
	<20110503165751.GA6566@bart.evergreen.loc>
	<710D4D6CE160654C87478D18385BB9971BE3FDCA46@MDC-MAIL-CMS01.ubisoft.org>
	<BANLkTi=W5HTLDa-UEvk4TefP3FyOvphxew@mail.gmail.com>
	<710D4D6CE160654C87478D18385BB9971BE3FDCA5C@MDC-MAIL-CMS01.ubisoft.org>
Date: Tue, 3 May 2011 23:45:40 +0100
Message-ID: <BANLkTi=Xt_DrHRmf8SViiAwgkAjCFLVX7A@mail.gmail.com>
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
From: Paul McEnery <pmcenery@gmail.com>
To: David Hill <david.hill@ubisoft.com>
Cc: =?ISO-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgiagio@gmail.com" <dgiagio@gmail.com>,
        "dborca@yahoo.com" <dborca@yahoo.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2011 18:41, David Hill <david.hill@ubisoft.com> wrote:
> That's not a problem, I can test it :)
>

I have applied Ben Hutching's patch [1] to the Github repository [2].
Updated Debian/Ubuntu packages are now available for testing [3].

Please test and report back. I'm sure Ben would also like to know if
this fix work :)

[1] - https://lkml.org/lkml/2011/5/3/283
[2] - https://github.com/dgiagio/ipheth/commit/46d6db65e0054cfae6f7355200b83f04e2fb9042
[3] - https://launchpad.net/~pmcenery/+archive/ppa
