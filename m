Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab1DLJdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:33:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38609 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1DLJdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OhI/vFZGecjWLuTdFXNE1HrfSLP1KrUu8UC8NRI1xugrnU0XV9s0ImvgTk19CcbNSK
         uDDwh5QRr5uL1VVJjomugGqxVk9yvCGZ6WlrMPuS0VeMe8B3P9FiwdidGWYiYI5lPt+U
         wyH/ErpVw3fJedomVKwwKBF5EhmhyLEPPk8Z8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104111437440.1975-100000@iolanthe.rowland.org>
References: <BANLkTikNb7FEDMbX3wSMti2e3muiaLZh-g@mail.gmail.com>
	<Pine.LNX.4.44L0.1104111437440.1975-100000@iolanthe.rowland.org>
Date: Tue, 12 Apr 2011 11:33:04 +0200
Message-ID: <BANLkTin0bKs1D3JxVODw3F+qH0ZqRwh5KA@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Alan Stern <stern@rowland.harvard.edu>:
> On Mon, 11 Apr 2011, Zdenek Kabelac wrote:
>
>> > I've created:
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=33062
>> >
>> > and I'm cc-ing linux-bluetooth.
>> >
>>
>> In fact this Ooops might be related to:
>>
>> http://marc.info/?l=linux-kernel&m=130207593728273&w=2
>
> It might be.  Did you try reverting the patch mentioned in that email?
>

Yep - it looks like the patch
http://marc.info/?l=linux-bluetooth&m=130230770920378&w=2
solved my problem with weird deadlocks.

Zdenek
