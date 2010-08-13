Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab0HMPDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:03:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934294Ab0HMPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DhgMf2P4N/y/1P3IqCgQKveGmkcE5xolGGkjQJrgq5yHUbORJd2aiNbBw3+m2EOVfi
         yrJN3hDKFieWdD1RXFIXhRXU2o8dagA7ilzulBwnSdoms4ez+R3PCrCbot341yj+3ilm
         dTDBTqMwzEYqsCaLb0iAckYA0BWHZjZ9eUCvo=
MIME-Version: 1.0
In-Reply-To: <20100813144929.GA25259@kroah.com>
References: <20100802141823.143b2a36.sfr@canb.auug.org.au>
	<20100813144929.GA25259@kroah.com>
Date: Fri, 13 Aug 2010 18:03:49 +0300
Message-ID: <AANLkTi=GY7ndsAhe4u0ZjpuGU8Bhh+dUxQt+oaNtvTC0@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree (usb tree related)
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 5:49 PM, Greg KH <greg@kroah.com> wrote:
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) produced these warnings:
>>
>> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_show_nofua' defined but not used
>> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_store_nofua' defined but not used
>> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_show_nofua' defined but not used
>> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_store_nofua' defined but not used
>>
>> Introduced by commit ed4825f7332669779540be27cb263daf22af3b1c ("USB:
>> gadget: storage: optional SCSI WRITE FUA bit") from the usb tree.
>
> Sorry about missing this, I have a patch to fix this up now.

I hope you are talking about last Michal's approach:
<550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>

-- 
With Best Regards,
Andy Shevchenko
