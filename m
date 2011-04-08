Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1DHRb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:31:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49800 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1DHRb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C/jpcK/obmbGI4XIy8gt+OFhsnRRsuONzQJ+ZeL9I/qjz0khWsJhwtAo/rNo6cFFck
         nNU62IbiYkaRrN/OUcUziejcoDSZkKHxdwMhTgy3vnip1GHuLjWAnh0xOtg9vXsWS9dt
         b/B9X8podFYxaC42rxHowDoZPgMed8zelhLbw=
MIME-Version: 1.0
In-Reply-To: <op.vtmqujir3ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
	<op.vtmqm7fw3ri7v4@arend-laptop>
	<BANLkTimy8LEqBqeJQD5SY=e8ZgEy8pRVHw@mail.gmail.com>
	<op.vtmqujir3ri7v4@arend-laptop>
Date: Fri, 8 Apr 2011 19:31:56 +0200
Message-ID: <BANLkTina48Z_BfHopVELJrnWt4bBDfE6PA@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Arend van Spriel <arend@broadcom.com>:
> On Fri, 08 Apr 2011 19:27:11 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>> OK, thanks. I'm compiling kernel with patch V2 right now. Of course
>> class included.
>>
>
> Great. I tried to apply you patch on my kernel tree but it did not apply.
> Which tree are you using. linux-next, wireless-next?

I'm using few days old wireless-testing. However, I've not idea how it
could not apply. That are mostly new files, we do not modify much of
current kernel code. Where did it fail to apply?

-- 
Rafał
