Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1DTMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:21:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34749 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1DTMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=TtD4DqDbv34qrHa9ivigg0yPaiW4qxZJMuQb4cY0hj92tu6SSdHua66622WvcpsG88
         9hj0UsZd7/yEnuSntvkI/tEbYrcyjSOD2+pqY6+LJJKLA6KmGFtCx0BN0iussmXMW3ut
         zftdkcCvTge0/DHVGUo3LxBG/woll1tK4kcJg=
MIME-Version: 1.0
In-Reply-To: <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
Date: Wed, 20 Apr 2011 14:21:51 +0200
X-Google-Sender-Auth: kmvzOD0PgNs4lXmHjcJFd_cuXBg
Message-ID: <BANLkTi=W7jaVtW1FThvG_ca57q+yDz1kzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/19 Ben Nizette <bn@niasdigital.com>:
> On 18/04/2011, at 10:26 PM, Alan Cox wrote:
>
>> The logical extension to that is to delete the gpio layer because the
>> board code can do it ?
>
> Well anything that is done once at startup, yes,

This patch is about biasing and drive modes. We need to alter
these at runtime (from board code, indeed) due to the fact that
when you go to sleep e.g. floating a pin yeilds better power
characteristics.

Linus Walleij
