Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1CHBXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:23:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1CHBXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:23:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pO0tzu/knrWHIKwXOiXP7FrjmdfE0oOOE9jCVf2oL2uS+gYAozomIPaJtM6IDL81wG
         n5GjBASr9yDkbO64ew9s0eB2Li6FG+mRmXs5lm2Bc+JncjqmFyFQ5mJ33BjivwHgSgCT
         yEcnhpL5E6F5yJ4RsjHknbdTQjCCDp9gdzT3E=
MIME-Version: 1.0
In-Reply-To: <20110308004300.GA11532@khazad-dum.debian.net>
References: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
	<20110308004300.GA11532@khazad-dum.debian.net>
Date: Mon, 7 Mar 2011 19:23:04 -0600
X-Google-Sender-Auth: 9kCRc-LLDuehv7bu5bYgbG-U0GU
Message-ID: <AANLkTinrEy+ed7Swfipx0OyKE_5_nyDOjMhunW5RrB7B@mail.gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absolutely, it enables hotkeys on a host of new Lenovo thinkpads,
x120e, T420, T520 etc.

-----------------------------------------------------
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement Team
------------------------------------------------------



On Mon, Mar 7, 2011 at 6:43 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 07 Mar 2011, Manoj Iyer wrote:
>> Please consider the following patch that adds support for auto loading
>> thinkpad_acpi module on newer Lenovo ThinkPads that have HKEY HID set
>> to LEN0068 instead of IBM0068.
>
> Does the driver do anything useful on these Lenovo thinkpads?
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
