Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0KGAUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 20:20:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43331 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0KGAUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cYgaknxo0V1V5Abf4ERVg60Q8LqagJ9xyJJYy+toJgtbmnsS45TuB7PDXoSKScpPRw
         5hjZLBn3JLEJroi9KU5ZPUhc0W9ELwJpNUEXX6MGQ+4pwuRj/DtPiXxZFJWY7jBqc2Qy
         VSX3x7Ni9AqPelkOJgorFutbYxSU0ww3w0P+8=
MIME-Version: 1.0
In-Reply-To: <20101107001341.4e39c631@lxorguk.ukuu.org.uk>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<20101106192259.GB2935@thunk.org>
	<AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
	<20101106234029.GC2935@thunk.org>
	<alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm>
	<20101107000348.GF2935@thunk.org>
	<20101107001341.4e39c631@lxorguk.ukuu.org.uk>
Date: Sat, 6 Nov 2010 17:20:45 -0700
Message-ID: <AANLkTimyZ75ZMsYYJnD32bpKObAfbBNJ0wUF42H-axV1@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 6, 2010 at 5:13 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sat, 6 Nov 2010 20:03:48 -0400
> "Ted Ts'o" <tytso@mit.edu> wrote:
>
>> On Sat, Nov 06, 2010 at 04:52:26PM -0700, david@lang.hm wrote:
>> > also, none of these other patches resulted in device drivers
>> > developed for a distro being incompatible with mainline.
>>
>> What, people can't delete a couple of single lines of code before
>> submitting the device driver upstream to mainline?
>
> I've always wondered that but never seen a good answer from the Android
> people as to why they don't push the stuff without the wakelock bits and
> just keep "add wakelock" patches for those as they do for the core kernel
> stuff they hack about.
>
I think the developers target for andriod kernel more than the
mainline.The biggest point of the hour is whether the device works for
Android Eclair, Android Froyo and not the see their patches in linux
kernel unfortunately.

Regards,
Ram.
