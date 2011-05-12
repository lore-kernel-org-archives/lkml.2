Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1ELFcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:32:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54535 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1ELFcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=olB3/oki5wDyuSIesxVASZYnbshaGVKv7mC8u93XiDlmG2d2gje+xw4jIlsPf9T+st
         QmeHjJ2bHoTl88/uvoL3ta1AKdUmFoPetDkSynsylot4UfpT/HzbmNStMEMgcmvWimWz
         GrIDyI1Ir84+u8l7h2KXOVQBPZEmuxaLYfLXI=
MIME-Version: 1.0
In-Reply-To: <20110512053236.GA26983@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<b6b196f84ae6b8f3c74ae20f4096b556e96503ee.1305177223.git.mfm@muteddisk.com>
	<20110512053236.GA26983@kroah.com>
Date: Wed, 11 May 2011 22:32:51 -0700
Message-ID: <BANLkTin=sdSp_kpL1SWSxZHBqa20RB3Y-A@mail.gmail.com>
Subject: Re: [PATCH 09/12 v3] staging: usbip: edit Kconfig and rename CONFIG options
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:32 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 11, 2011 at 10:17:08PM -0700, mfmooney@gmail.com wrote:
>> From: matt mooney <mfm@muteddisk.com>
>>
>> Change modules usbip_common_mod to usbip-core and usbip to usbip-host;
>> edit configuration option help text; rename CONFIG options to use a
>> USBIP prefix and change COMMON to CORE in both the Kconfig and
>> Makefiles; edit the menu entries and the driver descriptions.
>>
>> Signed-off-by: matt mooney <mfm@muteddisk.com>
>> ---
>> I actually change to module names in this patch now, and I had forgot to add that
>> into the commit message.
>
> I'm confused, there really isn't going to be 12 patches here in this new
> series, right?
>
> Care to start numbering them over and send them in a new thread so I can
> figure out what to apply in what order?
>
> thanks,
>
> greg k-h
>

Heh, sorry I didn't know what was easier for you.

-- 
GPG-Key: 9AFE00EA
