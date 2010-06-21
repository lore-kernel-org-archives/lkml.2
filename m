Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0FUCIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:08:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab0FUCIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hmLxrMtAFr6jgsEycI/7I0fvYsVwybr5+5jludKjutzDzzgZ7IBmhomnHclNamuZ55
         UCxvXuXXyqS6nghU/A7gX1VURnQqI7V/RmyxMsY3DQm1mou1ui6MDiZM0kiChdkWBvoH
         I0DjzEv7EzIH6/pbyRMSdVFlthtYwy9EBPuDM=
MIME-Version: 1.0
In-Reply-To: <20100618143727.GA16398@suse.de>
References: <AANLkTimx1HWYzG0qQqP12ObWQI1eiH5SoFpRic06uN3f@mail.gmail.com>
	<20100618143727.GA16398@suse.de>
Date: Mon, 21 Jun 2010 11:08:19 +0900
Message-ID: <AANLkTinPDECqU-GYKpD7_2IHb2qKjhCnViXkPDqN_cpu@mail.gmail.com>
Subject: Re: [PATCH] USB: serial: ftdi: correct merge conflict with CONTEC id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Radek Liboska <liboska@uochb.cas.cz>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I believe the merge problem occurred with the commit:

dee5658b482e9e2ac7d6205dc876fc11d4008138

Originally I submitted a patch and then they asked me to order the IDs
and resubmit, so did I. But unfortunately in the end somehow both
patches were merged.

[PATCH] USB: serial: ftdi: add CONTEC vendor and product id
[PATCH resubmit] USB: serial: ftdi: add CONTEC vendor and product id

Was I supposed to do the resubmit patch in a way that would unpatch
the first patch? Or is the word resubmit enough to know that this is
the good patch?

Thanks!
Dani

On Fri, Jun 18, 2010 at 11:37 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jun 18, 2010 at 03:30:02PM +0900, Daniel Sangorrin wrote:
>> This patch corrects a problem with the merge of a previous
>> patch to add the CONTEC identifier.
>
> What patch had the merge problem?  Did I just end up duplicating stuff
> incorrectly?  What was the git commit id?
>
> thanks,
>
> greg k-h
>
