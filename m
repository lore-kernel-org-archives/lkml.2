Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0HaFv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:51:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54556 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0HaFvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <000801cb48a8$9f907060$66f8800a@maildom.okisemi.com>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
 <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
 <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com>
 <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com> <alpine.LFD.2.00.1008301442290.9874@localhost6.localdomain6>
 <000801cb48a8$9f907060$66f8800a@maildom.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 30 Aug 2010 23:51:34 -0600
X-Google-Sender-Auth: skCFcH-en1jZvlkuj62CTM0TuJs
Message-ID: <AANLkTima_bfgguJv8-KTXadWzeTmRGtrzyppH4h=bDW8@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 7:05 PM, Masayuki Ohtake
<masa-korg@dsn.okisemi.com> wrote:
> Hi Thomas
>
>> > Yes, Intel Topcliff is new concept device.
>>
>> Thats right, but the question was whether the SPI peripheral is a new
>> IP design or similar to some already supported AMBA SPI peripheral.
>>
>> Maybe the Intel folks can shed some light on that.
>
> My answer was not appropriate.
> Though the Topcliff is new concept LSI, SPI in Topcliff is not a new design hardware but a reuse from other AMBA-based
> products.

Which product?  Is that product already supported by Linux?

g.
