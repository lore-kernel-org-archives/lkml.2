Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1EYIMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:12:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45599 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab1EYIMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n/UQ6NnIzySkkd4C92BW4P/y4E8lKAkQYqo1rFlOEO6FRrYw1++T1BXnb7UjzJOFH6
         4lTvYZ+y3ZT9Y9oWjm7kxMGGBgeXYTtKCEGb25LAdlcdHO3Bne0e2LySsM/110RYN4WI
         6k4oLn7C2P8+lOqFSXBgyk+YEeZUP6XvBsXPs=
MIME-Version: 1.0
In-Reply-To: <20110524230546.GC4652@n2100.arm.linux.org.uk>
References: <1306271221-28978-1-git-send-email-linus.walleij@stericsson.com>
	<20110524230546.GC4652@n2100.arm.linux.org.uk>
Date: Wed, 25 May 2011 10:12:51 +0200
X-Google-Sender-Auth: wc-5SOQhPQNSfcygI0dhfADb-Mg
Message-ID: <BANLkTinvBoce7UACjuUF3NnrVXk0_wyzFg@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio: move Nomadik GPIO driver to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> On Tue, May 24, 2011 at 11:07:01PM +0200, Linus Walleij wrote:
>> -config NOMADIK_GPIO
>> -     bool
>> -     help
>> -       Support for the Nomadik GPIO controller.
>> -
>
> What about the statements which select this config symbol?

Ayes, thanks a lot Russell, I've sent a separate patch deleting these.

Yours,
Linus Walleij
