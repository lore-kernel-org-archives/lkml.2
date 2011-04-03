Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1DCQCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:02:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53957 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1DCQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JGQt4wGCe0XvCTAISCJbPy70QAFm6aWCif9pW4WY/QD6m+xWaXtS94QAbUW4S82/bO
         4Rl2InJAHqn3hkjhBB0YWDKEEErU5vsRxOGEFodthhjlmN38MIR2snj2yOxcq3GAojXe
         6BiXtxBEy3QZ05rl0fLyrE52H+dKM9idysArA=
MIME-Version: 1.0
In-Reply-To: <20110403141509.GA27154@suse.de>
References: <1301455753-2866-1-git-send-email-bookjovi@gmail.com>
	<20110403100959.GA4834@p183.telecom.by>
	<20110403141509.GA27154@suse.de>
Date: Mon, 4 Apr 2011 00:02:50 +0800
Message-ID: <BANLkTinHiAdr93C2x7v4pHoRHgLTrvxmpw@mail.gmail.com>
Subject: Re: [PATCH] tty: update file header info correctly
From: Jovi Zhang <bookjovi@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 10:15 PM, Greg KH <gregkh@suse.de> wrote:
> On Sun, Apr 03, 2011 at 01:09:59PM +0300, Alexey Dobriyan wrote:
>> On Tue, Mar 29, 2011 at 11:29:13PM -0400, bookjovi@gmail.com wrote:
>> > From: Jovi Zhang <bookjovi@gmail.com>
>> >
>> > After some files changed location from drivers/char to driver/tty,
>> > file header info also need to update
>>
>> They should be _removed_ exactly to avoid this kind of patches.
>
> I agree, please remove these lines.
>
> thanks,
>
> greg k-h
>

Make sense, I will resend it.
