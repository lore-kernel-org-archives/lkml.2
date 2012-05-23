Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab2EWTAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:00:48 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55646 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2EWTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120522115638.GA19506@lizard>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
	<CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
	<4F9C1CF5.3050706@linaro.org>
	<20120505120835.GA26976@lizard>
	<4FBB79D5.7030108@linaro.org>
	<20120522115638.GA19506@lizard>
Date: Wed, 23 May 2012 21:00:45 +0200
Message-ID: <CACRpkdattvaG4ZUccan31dnW7Biw4=ReH9OuFEZXhUfDNKe6SA@mail.gmail.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
From: Linus Walleij <linus.walleij@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 1:56 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:

> Hi Lee,
>
> On Tue, May 22, 2012 at 12:34:45PM +0100, Lee Jones wrote:
>> Hi Anton,
>>
>> I see that this didn't make it into any of the v3.4-rc:s, hence v3.4
>> was released broken. Do you know when they're likely to make it into
>> Mainline?
>
> You probably should have told me that you needed these patches in
> v3.4, because neither Linus' nor yours patch description did not
> tell that these were urgent fixes (and not some stuff you'd just
> like to have for the future).

They are not super-urgent IMO, because there are no defconfigs
using them in v3.4.

Yours,
Linus Walleij
