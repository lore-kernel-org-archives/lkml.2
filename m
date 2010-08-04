Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0HDWDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:03:08 -0400
Received: from www84.your-server.de ([213.133.104.84]:59663 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0HDWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:02:59 -0400
Message-ID: <20100805000246.57246lmy2qeimft2@mail.your-server.de>
Date: Thu, 05 Aug 2010 00:02:46 +0200
From: stefani@seibold.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        tytso@mit.edu
Subject: Re: new gerneric kfifo API
References: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
 <1280905854.8441.3.camel@wall-e.seibold.net>
 <20100804194617.GA30773@suse.de>
 <1280952551.8594.0.camel@wall-e.seibold.net>
 <20100804201724.GA32100@suse.de>
 <20100804145205.524c1c03.akpm@linux-foundation.org>
In-Reply-To: <20100804145205.524c1c03.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Andrew Morton <akpm@linux-foundation.org>:

> On Wed, 4 Aug 2010 13:17:24 -0700
> Greg KH <gregkh@suse.de> wrote:
>
>> On Wed, Aug 04, 2010 at 10:09:11PM +0200, Stefani Seibold wrote:
>> > Am Mittwoch, den 04.08.2010, 12:46 -0700 schrieb Greg KH:
>> > > On Wed, Aug 04, 2010 at 09:10:54AM +0200, Stefani Seibold wrote:
>> > > > Hi,
>> > > >
>> > > > once again. Kernel 2.6.35 is out and i want to know if there  
>> is play plan to
>> > > > merge the generic kfifo API. All complains was fixed, so there is no
>> > > > reason to shift the merge again. Please gibe me a short answer.
>> > >
>> > > These have been in the -mm tree for a few major kernel releases now,
>> > > right?  And they are API safe, and only change the internals, right?
>> > >
>> > > If so, I see no objection to merging them now, especially as you will be
>> > > around to fix up any problems that people have, right?  :)
>> > >
>> >
>> > right!
>>
>> Great.  As Andrew doesn't have the time to send them on, want me to?  If
>> so, care to point me at them in his tree, or resend them to me?
>>
>
> One does a little more than "send things on"...
>
> I have a little pile of kfifo changes queud for 2.6.36.  The "generic
> kfifo" patches are a large rotorooting of the whole facility, based on
> that work (I hope).
>
> There's also the abandoned
> kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch
> which never got resolved with the originator.
>
>

This patch was included in the latest version i had posted last week.



