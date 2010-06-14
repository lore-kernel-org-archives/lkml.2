Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0FNURl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:17:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44809 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0FNURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UAkNXHk9nHfktgQs8SZ8Hv1shsV4lXw2KuZCPruJe3DM9NB9YTy3MDESGcpSvJIP5K
         JUBawx72FgHOqT0UnbMBWrEFdJIxC4inh6oW2JNuo1cpMIr8fmfUH7vpRaH7pESk4cu0
         L1cZd9ThrkCaQLkKKNMb8aCSTNNED73h7BSjA=
MIME-Version: 1.0
In-Reply-To: <20100614193554.GB19411@kroah.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
	<20100614162002.GA13902@kroah.com>
	<AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
	<20100614193554.GB19411@kroah.com>
Date: Tue, 15 Jun 2010 04:17:32 +0800
Message-ID: <AANLkTik7x3Sk5aNYqspLRt6nI3n_ME22XdasuA-K4Wcs@mail.gmail.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on 
	Linux-2.6.xx
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 3:35 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jun 15, 2010 at 02:44:36AM +0800, Jeff Chua wrote:
>> On Tue, Jun 15, 2010 at 12:20 AM, Greg KH <greg@kroah.com> wrote:
>> > On Mon, Jun 14, 2010 at 11:16:29PM +0800, Jeff Chua wrote:
>>
>>
>> > This is a warning that you can ignore, it's been fixed in the latest
>> > tree (2.6.35-rc3).
>> >
>> > try that and see.
>>
>> Greg,
>>
>> Ok, just tried rc3 and it's fixed the 1st OOPS.
>
> Note, it was not an oops, just a warning, and would not cause any
> problems.

Ok, understood.


>> But I'm still seeing the "ataX" incrementing from ata7 to ata8, ata9
>> ... after taking out and putting back the card. It seems the interface
>> is still not shutting down properly. ... Any command to shutdown it
>> down gracefully?
> I don't know, maybe the libata developers can help you out here.
> good luck,

Cool.  Hopefully someone has the solution.

Thanks!

Jeff
