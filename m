Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1DTMch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:32:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39009 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1DTMcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MZsiMazI9cEvX2ZTGPS9GHONMG8pDq+5yRRT8J94SZia4QvHgoavmRAEhWGxUe62GT
         G4I/lCRtirasEN6lN8aWuNv/W+1aT728sKD3hISkseJfxwQO347y2ciWhUpyo97OWnIW
         jTw/5ycnV1KO8dcSaYg57TNABNyjQTtHNS+8g=
MIME-Version: 1.0
In-Reply-To: <BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
Date: Wed, 20 Apr 2011 14:32:35 +0200
X-Google-Sender-Auth: 1PYxNi4590Ghu48D2QRpo2d4-OA
Message-ID: <BANLkTimfkpjQ9DoYKRTVwyvtPRccO+RwpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ben Nizette <bn@niasdigital.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/19 Kyungmin Park <kmpark@infradead.org>:

> One more consideration, not mentioned previous time, is that pin
> configuration for power down mode.
> Samsung SoCs has retention GPIO configurations at sleep (suspend)
> mode. and restore it at resume time.
> it's need to reduce power and proper operation after suspend.

Isn't this supposed to be handled by runtime_pm hooks inside
your GPIO driver rather than by someone else talking to
the GPIO driver trying to spool/unspool the state from the
outside in some other place?

Or am I getting things backwards now...?

Yours,
Linus Walleij
