Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0F3V72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:59:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48685 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0F3V71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=L0WEzWNl4bj+f5I/0UubZpVkRn+QqhZvmjxeMOY/S3iPerVhDOWzoiFQ+c5jmjQOyh
         m22ytXcoY1fQzZbCMKexAbv3GbqGv968EHkQo3BT8e77+Vs/lG/A/FMA+flY9bafwFbM
         MBW78bB+CK7oIFjKibU7UQ+Ud6COu3kG1//yM=
MIME-Version: 1.0
In-Reply-To: <4C2BBACF.3080405@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
Date: Wed, 30 Jun 2010 14:59:25 -0700
X-Google-Sender-Auth: DnCRkoy5z1m7HJA2PTPC2TKRlFs
Message-ID: <AANLkTil5fCb9maq5qE-2txxaybGqVQSWEy8q0ppBsype@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 2:44 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> Chris, is there a BIOS update available for your platform?

You mean the EFI firmware update? Nope.

Do you think loading linux via EFI instead of boot camp (BIOS) will help?

Chris
