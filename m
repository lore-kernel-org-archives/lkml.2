Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1CXR4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:56:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41479 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1CXR4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Q22TgNIb/QGKA66cGZyXQsq2m7P40/3RFsekcHspyWfIs1xROV79L80vJ+CnfsOZIR
         D7AeUXwXG3cYcjMGUhTaAKxpGuLBJiTS8OTknzpY/TjGeTtBgZ48LTIQ0udN/bYIUsww
         MO9C6Z7hbglk8Z9smfR0VG0Rc5BP5jIOdKTP0=
MIME-Version: 1.0
In-Reply-To: <20110324174722.GH3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com> <20110324174722.GH3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 13:56:17 -0400
X-Google-Sender-Auth: 0Xoz2P8j52OPG0CNzEX1SSHV1jA
Message-ID: <AANLkTinDWA1xU1G0kBk8XPr_ZaRgHtBQP60DX6-x3tsn@mail.gmail.com>
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 13:47, Jamie Iles wrote:
> On Thu, Mar 24, 2011 at 01:39:56PM -0400, Mike Frysinger wrote:
>> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
>> > Mike, I wasn't 100% sure how big the blackfin OTP is but I found a
>> > datasheet talking about 64KB so I've assumed that for now.
>>
>> the datasheets say 64K *bits* :).  i think all our datasheets tend to
>> use bits rather than bytes because they're stupid and bigger numbers
>> always means better parts !
>
> That sounds very familiar!

just an overview note here ... the Blackfin OTP is actually IP we
bought from someone (not sure if i can say more, although i dont know
the details myself ... i'd have to go ask around), so much of the
feedback i give about the structure of it most likely (hopefully) be
applicable to other people who have purchased this IP.  if/when anyone
who is also using this IP steps forward, we could even see about
generalizing the bfin-otp driver.
-mike
