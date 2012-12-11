Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2LKJhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:37:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32777 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LKJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZJFbHSwowKnfWyXLckVePHrC6o2CtDJaFb+dXTkNYPjw@mail.gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-7-git-send-email-lee.jones@linaro.org>
	<CACRpkdZJFbHSwowKnfWyXLckVePHrC6o2CtDJaFb+dXTkNYPjw@mail.gmail.com>
Date: Tue, 11 Dec 2012 10:37:28 +0100
Message-ID: <CAPDyKFo6KhshYJfSvodPK4e7zC25etz0G8fV4jnAssZX3BDZBg@mail.gmail.com>
Subject: Re: [PATCH 06/12] ARM: ux500: Set correct MMCI regulator voltages in
 the ux5x0 Device Tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2012 10:17, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> The voltages for the MMCI GPIO controlled voltage regulation differ
>> depending on who you believe and where you pick the information up
>> from. More recent internal code suggests that the true upper voltage
>> from the shifter is actually v3.3, instead of the previously
>> indicated v2.9. Let's mirror that change in the Device Tree file.

This is wrong. The value should be 2.9V nothing else!

>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij

Kind regards
Ulf Hansson
