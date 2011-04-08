Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1DHQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:56:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60047 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1DHQ4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mS+UNWRl8S6JdrVjPJC6Sf75QhIA1JekWog+t1bW9M8pWrqQF/4ETDFDsa+MQiNAix
         tH9nuWOzg6BSkDBETVsy+NgcnxqkzYmCKqDg5iaajha5ZYG0VMtXNwPVVMoQPsbXuWay
         lXzxGGWp+Z7C3qEyoTsTvogo06T+nb5l4fRF4=
MIME-Version: 1.0
In-Reply-To: <op.vtisojsk3ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
Date: Fri, 8 Apr 2011 18:56:13 +0200
Message-ID: <BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
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

2011/4/6 Arend van Spriel <arend@broadcom.com>:
> 3. Device identification
>
> The cores are identified by manufacturer, core id and revision in your
> patch. I would not use the revision because 4 out of 5 times a revision
> change does indicate a hardware change but no change in programming
> interface. The enumeration data does contain a more selective field
> indicating the core class (4 bits following the core identifier). I suggest
> to replace the revision field by this class field.

Could you say something more about *class*, please? For my BCM43224 it
seems to be 0x0. WIll check BCM4313 in a moment.

-- 
Rafał
