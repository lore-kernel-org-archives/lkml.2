Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0HaGxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:53:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56450 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab0HaGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <004101cb48d8$67e1acd0$66f8800a@maildom.okisemi.com>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
 <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
 <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com>
 <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com> <AANLkTikpj6Q6QjFn4S9cYfBiKbMNQB_N2ptHEAvfW0wb@mail.gmail.com>
 <001501cb48ae$262d8d60$66f8800a@maildom.okisemi.com> <AANLkTi=Q_16S4+AGk=BjiKHZjjeon=-OmPz4QKmRZ+h2@mail.gmail.com>
 <004101cb48d8$67e1acd0$66f8800a@maildom.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Aug 2010 00:53:15 -0600
X-Google-Sender-Auth: SSCblrBvWx2LtiyR2UHa1peLxuA
Message-ID: <AANLkTimmOdiAdjxix_JQUG21bYRU2bKw7OD=0HJDWwLy@mail.gmail.com>
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

On Tue, Aug 31, 2010 at 12:47 AM, Masayuki Ohtake
<masa-korg@dsn.okisemi.com> wrote:
>> Regardless, the topcliff spi driver can still be merged into mainline
>> without the spi_device registration code, and you can keep your
>> personal copy of spi_pch_device.c for testing while the details about
>> device tree support for x86 get worked out.
>>
>> g.
>>
> Hi Grant,
>
> Thank you very much.
> I could understand well.
>
> Can I post our SPI patch for Topcliff without 'of_node' code and spi_device registration code?

yes.

g.
