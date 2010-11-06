Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0KFXmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 19:42:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54352 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0KFXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 19:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cB12H+RKdbtml/nlcq2wAvPWtKCTwBf5Bu9W7+Vbg4jE/IgutZFXNOr1yLqnBoncfq
         4WFY3jtTzja6fA/EoVAhrmZ6JoBybHg2IfzUUSK4hsGEpf8BBICf9LVLlGAFYZdIUSmr
         +rQg2wlvunMO3pBLVDXTfbMjNMTLZrKdejTOc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<20101106192259.GB2935@thunk.org>
	<AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
Date: Sat, 6 Nov 2010 16:42:39 -0700
Message-ID: <AANLkTikTzxOa6CEg6J4vaxWMQ4Y4Ykz_qMUiZtbtpy++@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 6, 2010 at 12:40 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> I think you need to see this: https://review.source.android.com/#change,18761\
I have point here all the vendors working on Android are now targeting
their so called open source maintance only targeted towards kernel
maintained on Googles code base git.android.kernel.org.

For example for the same above kernel/tegra ,compare the board
files(board-harmony.c) from same vendor in android.kernel.org
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=arch/arm/mach-tegra/board-harmony.c;h=9e305de56be9ac28ab023dbfc4f748c5f260bec1;hb=f6f94e2ab1b33f0082ac22d71f66385a60d8157f
and in mainline kernel.org for the same vendor board file I see
http://android.git.kernel.org/?p=kernel/tegra.git;a=history;f=arch/arm/mach-tegra/board-harmony.c;h=ee01dd0ae7cd16ae6d207a540d875d3516d53797;hb=linux-tegra-2.6.36

This i dont really understand why.This is the same in case of other
key chipset vendors.
> And this: http://galaxytab.samsungmobile.com/
The above link yes a samsung galaxy tab is an android product so ??

Thanks and regards,
Ram
>
